import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/newPostDraftScreen.dart';
import 'package:first_app/screens/post_draft_screen.dart';
import 'package:first_app/providers/user_provider.dart';
import 'package:first_app/services/crud/post_service.dart';
import 'package:first_app/widgets/like_animation.dart';
import 'package:first_app/screens/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:first_app/screens/post_draft_screen.dart';
import '../main.dart';
import '../models/user.dart';
import '../screens/post_draft_screen.dart';
import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

int i = 0;

class DraftCard extends StatefulWidget {
  final snap;
  const DraftCard({
    Key key,
    @required this.snap,
  }) : super(key: key);

  @override
  State<DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard> {
  @override
  void initState() {
    super.initState();
  }

  // Widget EditDraft(String postId) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: [
  //         IconButton(
  //             onPressed: (() {
  //               Navigator.of(context).pop();
  //             }),
  //             icon: Icon(Icons.arrow_back))
  //       ],
  //     ),
  //     body: PostDraftPage(),
  //   );
  // }

  deleteDraft(String postId) async {
    try {
      await PostService().deleteDraft(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0)
                .copyWith(right: 4),
            child: Row(children: [
              //header section
            ]),

            //image section
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
                //height: MediaQuery.of(context).size.height,
                //width: double.infinity,
                child: Image.network(
              //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfw8zy3G7-GYrDilkANhTaVIKEwEuVycOGsj7k4wtXsrasmJ03ZV9AUMsntAOugN26NLg&usqp=CAU',
              widget.snap['postUrl'],
              fit: BoxFit.cover,
            )),
          ),

          //SECTION
          Row(
            children: [
              IconButton(
                alignment: Alignment.center,
                onPressed: () {
                  //print("print");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => editDraft(
                              context,
                              widget.snap['postUrl'],
                              widget.snap['category'],
                              widget.snap['description'],
                              widget.snap['geoLoc'],
                              widget.snap['location'],
                              widget.snap['postId'],
                            )),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  deleteDraft(widget.snap['postId']);
                  // Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete_outline,
                ),
              ),
            ],
          ),
          //Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['description']}',
                        )
                      ])),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget editDraft(BuildContext context, String PostURL, String category,
    String Description, GeoPoint geoLoc, String Location, String postID) {
  return Scaffold(
    body: newPostDraftScreen(
      postURL: PostURL,
      category: category,
      description: Description,
      location: Location,
      geoLoc: geoLoc,
      postID: postID,
    ),
  );
}
