import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/main.dart';
import 'package:first_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../widgets/notification_card.dart';
import '../widgets/post_card.dart';
import '../providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewNotification extends StatefulWidget {
  @override
  _NewNotificationState createState() => _NewNotificationState();
}

class _NewNotificationState extends State<NewNotification> {
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
        future: FirebaseFirestore.instance
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

        /*builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("data not found");
          }
          return Text("data found");
        },*/
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
                NotifCard(snap: snapshot.data.docs[index].data()),
          );
        },
      ),
    );
  }
}



/*class _NotificationsState extends State<Notifications> {
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



