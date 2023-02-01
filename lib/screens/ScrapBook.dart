import 'package:first_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/like_animation.dart';
import 'comment_screen.dart';

class scrapbook extends StatefulWidget {
  final snap;
  const scrapbook({Key key, this.snap}) : super(key: key);

  @override
  State<scrapbook> createState() => _scrapbookState();
}

class _scrapbookState extends State<scrapbook> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(200, 50),
            child: AppBar(
              iconTheme: IconThemeData.fallback(),
              backgroundColor: Colors.white,
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
                        onPressed: (() async {
                          await FireStoreMethods().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes']);
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
