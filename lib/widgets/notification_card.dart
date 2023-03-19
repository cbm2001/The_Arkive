import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/providers/user_provider.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:first_app/services/crud/notification_service.dart';
import 'package:first_app/widgets/like_animation.dart';
import 'package:first_app/screens/comment_screen.dart';
import 'package:first_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class NotifCard extends StatefulWidget {
  final snap;
  const NotifCard({
    Key key,
    @required this.snap,
  }) : super(key: key);
  @override
  State<NotifCard> createState() => _NotifCardState();
}

Widget mediaPreview;
String notificationItemText;

class _NotifCardState extends State<NotifCard> {
  @override
  void initState() {
    super.initState();
  }

  deleteNotif() async {
    try {
      await NotificationService().removeNotif(
          widget.snap['notifId'], FirebaseAuth.instance.currentUser.uid);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  configureMediaPreview() {
    if (widget.snap['type'] == 'likes' || widget.snap['type'] == 'Comments') {
      mediaPreview = GestureDetector(
        onTap: (() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(uid: FirebaseAuth.instance.currentUser.uid),
            ),
          );
        }),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          CachedNetworkImageProvider(widget.snap['postUrl']))),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = GestureDetector(
        onTap: (() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(uid: FirebaseAuth.instance.currentUser.uid),
            ),
          );
        }),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          widget.snap['folderUrl']))),
            ),
          ),
        ),
      );
    }

    if (widget.snap['type'] == 'likes') {
      notificationItemText = "liked your post";
    } else if (widget.snap['type'] == 'Comments') {
      var text = widget.snap['text'];
      notificationItemText = " replied : $text";
    } else if (widget.snap['type'] == 'folders') {
      var text = widget.snap['folder'];
      notificationItemText = "sent a request to collaborate on folder $text";
    } else {
      notificationItemText = "Error: Unknown type $widget.snap['type'] ";
    }
  }

  Widget build(BuildContext context) {
    configureMediaPreview();
    return Container(
      width: double.infinity,
      child: Card(
        //elevation: 1.5,
        margin: EdgeInsets.only(left: 1.0, right: 1.0, top: 4.0, bottom: 4.0),
        color: Colors.white,
        child: ListTile(
          onTap: (() {
            /*widget.snap['type'] == 'folders'
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          uid: FirebaseAuth.instance.currentUser.uid),
                    ),
                  )
                //Navigator.pop(context);
                : */
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(uid: FirebaseAuth.instance.currentUser.uid),
              ),
            );
            Navigator.pop(context);
          }),
          title: GestureDetector(
            onTap: (() {
              /* if (widget.snap['type'] == 'folders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(uid: FirebaseAuth.instance.currentUser.uid),
                  ),
                );
                Navigator.pop(context);
              } else {*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(uid: FirebaseAuth.instance.currentUser.uid),
                ),
              );
              Navigator.pop(context);
            }),
            child: Row(
              children: [
                //Padding(padding: EdgeInsets.only(left: 8.0)),
                /*CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.snap['userProfile'])),*/
                SizedBox(
                  width: 190,
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' $notificationItemText',
                            )
                          ])),
                ),
                SizedBox(width: 12),
                mediaPreview,
                IconButton(
                  onPressed: (() {
                    showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) => Dialog(
                            child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text('Delete Notification'),
                                      ),
                                      onTap: () {
                                        deleteNotif();
                                        Navigator.pop(context);
                                      }),
                                ].toList())));
                  }),
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.snap['userProfile'])),
          subtitle: Text(
            timeago.format(widget.snap['timeStamp'].toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          /*trailing: IconButton(
            onPressed: (() {
              showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) => Dialog(
                      child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Text('Report Post'),
                                ),
                                onTap: () {}),
                          ].toList())));
            }),
            icon: Icon(Icons.more_vert),
          ),*/
        ),
      ),
    );
  }
}

class notifPost extends StatefulWidget {
  final snap;
  const notifPost({Key key, this.snap}) : super(key: key);

  @override
  State<notifPost> createState() => _notifPostState();
}

class _notifPostState extends State<notifPost> {
  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(200, 50),
          child: AppBar(
            iconTheme: IconThemeData.fallback(),
            backgroundColor: Colors.white,
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
          )),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                    .copyWith(right: 0),
                child: Row(children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['userProfile'].toString(),
                    ),
                  ),
                  /*Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ))),*/
                  /*widget.snap['userId'].toString() ==
                          FirebaseAuth.instance.currentUser.uid
                      ? IconButton(
                          onPressed: (() {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) => Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [].toList())),
                            );
                          }),
                          icon: Icon(Icons.more_vert),
                        )
                      : IconButton(
                          onPressed: (() {
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) => Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        InkWell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text('Report Post'),
                                            ),
                                            onTap: () {}),
                                      ].toList())),
                            );
                          }),
                          icon: Icon(Icons.more_vert),
                        )*/
                ]),

                //image section
              ),
              SizedBox(
                  //height: MediaQuery.of(context).size.height,
                  //width: double.infinity,
                  child: Image.network(
                //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfw8zy3G7-GYrDilkANhTaVIKEwEuVycOGsj7k4wtXsrasmJ03ZV9AUMsntAOugN26NLg&usqp=CAU',
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              )),

              //LIKE COMMENT SECTION
              Row(
                children: [
                  IconButton(
                    onPressed: (() => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: widget.snap['postId'])))),
                    icon: const Icon(
                      Icons.comment_outlined,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {}),
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
