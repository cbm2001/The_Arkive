import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/post_draft_screen.dart';
import 'package:first_app/providers/user_provider.dart';
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

  Widget EditDraft(String postId) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              icon: Icon(Icons.arrow_back))
        ],
      ),
      body: PostDraftPage(),
    );
  }

  deleteDraft(String postId) async {
    try {
      await FireStoreMethods().deleteDraft(postId);
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
              /*SizedBox(
                height: 70,
              ),*/
              /*CircleAvatar(
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
                      ))),*/
              /*IconButton(
                padding: EdgeInsets.only(left: 300),
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
                                    child: Text('Delete Draft'),
                                  ),
                                  onTap: () {
                                    deleteDraft(
                                      widget.snap['postId'].toString(),
                                    );
                                    // remove the dialog box
                                    Navigator.of(context).pop();
                                  }),
                              InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Edit Draft'),
                                  ),
                                  onTap: () {
                                    print("hello");
                                    return Scaffold();
                                    // EditDraft(
                                    //   widget.snap['postId'].toString(),
                                    // );
                                    // remove the dialog box
                                    Navigator.of(context).pop();
                                  })
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
              )*/
              /* IconButton(
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
                                          /*deletePost(
                                              widget.snap['postId'].toString(),
                                            );
                                            // remove the dialog box
                                            Navigator.of(context).pop();*/
                                        }),
                                  ].toList())),
                        );
                      }),
                      icon: Icon(Icons.more_vert),
                    )*/
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
                            )),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  var x = FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']);
                  //print("print");
                  //showDialog(context: context, builder: builder)
                  x.delete();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(uid: Provider.of<UserProvider>(context).getUser.uid)),
                  );
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
    String Description, GeoPoint geoLoc, String Location) {
  return Scaffold(
    body: PostDraftPage(
      postURL: PostURL,
      category: category,
      description: Description,
      location: Location,
      geoLoc: geoLoc,
    ),
  );
}
