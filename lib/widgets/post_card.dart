import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/providers/user_provider.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:first_app/widgets/like_animation.dart';
import 'package:first_app/screens/comment_screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key key,
    @required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  int folderlen = 0;
  List folderlist = [];

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      QuerySnapshot folders = await FirebaseFirestore.instance
          .collection('folders')
          .where('users', arrayContains: userData['uid'])
          .get();

      commentLen = snap.docs.length;
      folderlen = folders.docs.length;
      folderlist = folders.docs;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    // setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  addpostTF(String folderId, String postId) async {
    try {
      await FireStoreMethods().addPostToFolder(folderId, postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                .copyWith(right: 0),
            child: Row(children: [
              //header section
              /*SizedBox(
                height: 70,
              ),*/
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  widget.snap['profImage'].toString(),
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ))),
              widget.snap['uid'].toString() == user.uid
                  ? IconButton(
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
                                          child: Text('Delete Post'),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.snap['postId'].toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                    /*InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text('Report Post'),
                                        ),
                                        onTap: () {
                                          /*deletePost(
                                              widget.snap['postId'].toString(),
                                            );
                                            // remove the dialog box
                                            Navigator.of(context).pop();*/
                                        }),*/
                                  ].toList())),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text('Report Post'),
                                        ),
                                        onTap: () {

                                          var x = FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']);
                                          x.update({"flag":true});
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  ].toList())),
                        );
                      }),
                      icon: Icon(Icons.more_vert),
                    )
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
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                child: IconButton(
                  onPressed: widget.snap['likes'].contains(user.uid)
                      ? (() async {
                          await FireStoreMethods().unlikePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes']);
                          await FireStoreMethods().removeLikefromNotif(
                            widget.snap['notifId'],
                            widget.snap['uid'],
                          );

                          // addLikeNotif(widget.snap['postId']);
                        })
                      : (() async {
                          await FireStoreMethods().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes']);
                          await FireStoreMethods().addLiketoNotif(
                              widget.snap['postId'],
                              widget.snap['uid'],
                              user.username,
                              widget.snap['postUrl'],
                              user.photoUrl.toString());

                          // addLikeNotif(widget.snap['postId']);
                        }),
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: (() => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CommentsScreen(postId: widget.snap['postId'])))),
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
                width: 140,
              ),
              IconButton(
                onPressed: (() {}),
                icon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: (() {
                  // show list of folders (FirebaseFirestore.instance.collection('folders').where('users', arrayContains: user.uid).get() then use addPostToFolder() to add post to folder)
                  showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Add to folder"),
                          content: Container(
                            height: 300,
                            width: 300,
                            child: ListView.builder(
                              itemCount: folderlen,
                              itemBuilder: (context, index) {
                                if (folderlist[index]['posts']
                                    .contains(widget.snap['postId'])) {
                                  return ListTile(
                                    title:
                                        Text(folderlist[index]['folderName']),
                                    subtitle: Text('Already in folder'),
                                  );
                                }
                                return ListTile(
                                  // check if post is already in folder

                                  title: Text(folderlist[index]['folderName']),

                                  onTap: () {
                                    addpostTF(folderlist[index]['folderId'],
                                        widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      });
                }),
                icon: const Icon(
                  Icons.bookmark_border_outlined,
                  color: Colors.black,
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
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text('${widget.snap['likes'].length} likes'
                      //style: TextStyle(color: Colors.black),
                      ),
                ),
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
