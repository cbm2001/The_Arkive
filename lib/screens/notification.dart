import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/main.dart';
import 'package:first_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../resources/local_notifications.dart';
import '../widgets/post_card.dart';
import '../providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewNotification extends StatefulWidget {
  @override
  _NewNotificationState createState() => _NewNotificationState();
}

class _NewNotificationState extends State<NewNotification> {
  List<NotificationItem> notifItems = [];
  getNotifications() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notifItems')
        .orderBy('timeStamp', descending: true)
        .get();

    snapshot.docs.forEach((element) {
      //notifItems.add(NotificationItem.fromDocument(element));
      //notifItems.add(element.data());
      //notifItems.add(NotificationItem.fromDocument(element));
      notifItems.add(NotificationItem.fromDocument(element));
      //notifItems.add(NotificationItem.fromDocument(element.data()));
      print("Notification Item : ${element.data()}");
    });
    return notifItems;
    //return snapshot.docs;
  }

  List<NotificationItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      //body: FutureBuilder<NotificationItem>(
      body: /*ListView.builder(
        itemBuilder: (context, index) {
          
        },*/
          FutureBuilder(
        future: //getNotifications(),
            FirebaseFirestore.instance
                .collection('notifications')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('notifItems')
                .orderBy('timeStamp', descending: true)
                .get(),
        // .then((value) => value.docs.forEach((element) {
        //       items.add(NotificationItem.fromDocument(element));
        //       print("Notification Item : ${element.data()}");
        //     })),
        //List<NotificationItem> notifItems = [];

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("data not found");
          }
          return Text("data found");
        },
      ),
    );
  }
}

Widget mediaPreview;
String notificationItemText;

class NotificationItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String userProfile;
  final String postId;
  final String postUrl;
  final String text;
  final Timestamp timeStamp;

  NotificationItem({
    this.postId,
    this.postUrl,
    this.text,
    this.timeStamp,
    this.type,
    this.userId,
    this.userProfile,
    this.username,
  });

  factory NotificationItem.fromDocument(DocumentSnapshot doc) {
    return NotificationItem(
      postId: doc['postId'],
      postUrl: doc['postUrl'],
      text: doc['text'],
      timeStamp: doc['timeStamp'],
      type: doc['type'],
      userId: doc['userId'],
      userProfile: doc['userProfile'],
      username: doc['username'],
    );
  }

  /*factory NotificationItem.fromDocument(Map<String, dynamic> doc) {
    return NotificationItem(
      postId: doc['postId'],
      postUrl: doc['postUrl'],
      text: doc['text'],
      timeStamp: doc['timeStamp'],
      type: doc['type'],
      userId: doc['userId'],
      userProfile: doc['userProfile'],
      username: doc['username'],
    );
  }*/

  configureMediaPreview() {
    if (type == 'likes' || type == 'Comments') {
      mediaPreview = GestureDetector(
        onTap: () => print('showing post'),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(postUrl))),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'likes') {
      notificationItemText = "liked your post";
    } else if (type == 'Comments') {
      notificationItemText = 'replied : $text';
    } else {
      notificationItemText = "Error: Unknow type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview();
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.blue,
        child: ListTile(
          title: GestureDetector(
            onTap: (() => print("show profile")),
            child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $notificationItemText',
                      )
                    ])),
          ),
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfile)),
          subtitle: Text(
            timeago.format(timeStamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
/*

class _NotificationsState extends State<Notifications> {
  getNotifications() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("notifItems")
        .orderBy("timeStamp", descending: true)
        .limit(50)
        .get();
    List<NotificationItem> notifItems = [];
    snapshot.docs.forEach((element) {
      //notifItems.add(NotificationItem.fromDocument(element));
      notifItems.add(element.data());
      print("Notification Item : ${element.data()}");
    });
    return notifItems;
  }
  /*String notificationMsg = "Waiting for notifications";
  void initState() {
    super.initState();

    //LocalNotificationService.initilize();

    // Terminated State
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          notificationMsg =
              "${event.notification.title} ${event.notification.body} I am coming from terminated state";
        });
      }
    });

    // Foreground State
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(event);
      setState(() {
        notificationMsg =
            "${event.notification.title} ${event.notification.body} I am coming from foreground";
      });
    });

    // background State
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificationMsg =
            "${event.notification.title} ${event.notification.body} I am coming from background";
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "Notifications",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.0,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
          ),
          body: /*Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Text("Notification Body"),
              ),
            )
          ],
        ),*/
              Container(
                  /*child: FutureBuilder(
                future: getNotifications(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    //return CircularProgressIndicator(color: Colors.black);
                    return Text("data not found");
                  }

                  return ListView(children: snapshot.data);
                })),*/
                  child: Container(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("notifications")
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection("notifItems")
                  .orderBy("timeStamp", descending: true)
                  .limit(50)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (ctx, index) =>
                      PostCard(snap: snapshot.data.docs[index].data()),
                );
              },
            ),
          ))),
    );
  }
}*/


