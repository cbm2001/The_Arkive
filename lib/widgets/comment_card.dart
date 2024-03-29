import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/user_profile.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key key, @required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FirebaseAuth.instance.currentUser.uid ==
                              snap.data()['uid']
                          ? InkWell(
                              onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                        uid: snap.data()['uid'],
                                      ),
                                    ),
                                  ),
                              child: Text(snap.data()['name'],
                                  //text: 'username',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )))
                          : InkWell(
                              onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserProfilePage(
                                        uid: snap.data()['uid'],
                                      ),
                                    ),
                                  ),
                              child: Text(snap.data()['name'],
                                  //text: 'username',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))),
                      Expanded(
                          child: RichText(
                        text: TextSpan(
                          children: [
                            /*TextSpan(
                                    text: snap.data()['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      colo
                                    )),*/

                            TextSpan(
                                text: ' ${snap.data()['text']}',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      //'12/11/23',
                      DateFormat.yMMMd()
                          .format(snap.data()['datePublished'].toDate()),

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          /*Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )*/
        ],
      ),
    );
  }
}
