import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/providers/user_provider.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:first_app/services/crud/folder_service.dart';
import 'package:first_app/widgets/like_animation.dart';
import 'package:first_app/screens/comment_screen.dart';
import 'package:first_app/widgets/post_card.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class FolderCard extends StatefulWidget {
  final snap;
  const FolderCard({
    Key key,
    @required this.snap,
  }) : super(key: key);
  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  @override
  void initState() {
    super.initState();
  }

  addpost(String folderId, String postId) async {
    try {
      await FolderService().addPostToFolder(folderId, postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  adduser(String folderId, String uid, String username) async {
    try {
      if (uid ==
          Provider.of<UserProvider>(context, listen: false).getUser.uid) {
        showSnackBar(
          context,
          "You can't add yourself to a folder",
        );
        return;
      }
      if (widget.snap["users"].contains(uid)) {
        showSnackBar(
          context,
          "This user is already in the folder",
        );
        return;
      }
      await FolderService().addUserToFolder(folderId, uid, username);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  deletepost(String folderId, String postId) {
    try {
      FolderService().removePostFromFolder(folderId, postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  deleteuser(String folderId, String uid, String username) {
    try {
      FolderService().removeUserFromFolder(folderId, uid, username);
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
      child: ElevatedButton(
        child: Text(widget.snap["folderName"]),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => folderScreen(
                folderId: widget.snap["folderId"],
                folderName: widget.snap["folderName"],
                posts: widget.snap["posts"],
              ),
            ),
          );
        },
        onLongPress: () {
          // if (widget.snap["users"] is in Provider.of<UserProvider>(context, listen: false).getUser.username then show delete button)
          if (widget.snap["users"].contains(
              Provider.of<UserProvider>(context, listen: false).getUser.uid)) {
            // show 3 options: delete folder, add user, remove user
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Folder options"),
                  content: Text("What would you like to do?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Delete folder"),
                      onPressed: () {
                        FolderService().deleteFolder(widget.snap["folderId"]);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text("Add user"),
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.snap["requests"].length > 0) {
                          // show list of requests with a checkbox next to each one and a button to add them
                          List<bool> _checkboxStates = List.generate(
                              widget.snap["requests"].length, (index) => false);

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Add user"),
                                content: Container(
                                  height: 300,
                                  width: 300,
                                  child: ListView.builder(
                                    itemCount: widget.snap["requests"].length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                        future: FolderService().getUser(
                                            widget.snap["requests"][index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListTile(
                                              title: Text(
                                                  snapshot.data["username"]),
                                              trailing: ElevatedButton(
                                                child: Text("Add"),
                                                onPressed: () {
                                                  FolderService()
                                                      .addUserToFolder(
                                                    widget.snap["folderId"],
                                                    snapshot.data["uid"],
                                                    snapshot.data["username"],
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Add user"),
                                content: Text(
                                    "There are no requests to add to this folder"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    // remove user
                    ElevatedButton(
                      child: Text("Remove user"),
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.snap["users"].length > 0) {
                          // show list of users with a checkbox next to each one and a button to remove them
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Remove user"),
                                content: Container(
                                  height: 300,
                                  width: 300,
                                  child: ListView.builder(
                                    itemCount: widget.snap["users"].length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                        future: FolderService().getUser(
                                            widget.snap["users"][index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListTile(
                                              title: Text(
                                                  snapshot.data["username"]),
                                              trailing: ElevatedButton(
                                                child: Text("Remove"),
                                                onPressed: () {
                                                  FolderService()
                                                      .removeUserFromFolder(
                                                    widget.snap["folderId"],
                                                    snapshot.data["uid"],
                                                    snapshot.data["username"],
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Remove user"),
                                content: Text(
                                    "There are no users to remove from this folder"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
          // else show request to join button if not already requested
          else if (widget.snap["requests"].contains(
              Provider.of<UserProvider>(context, listen: false).getUser.uid)) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Request to join"),
                  content:
                      Text("You have already requested to join this folder"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Request to join"),
                  content: Text(
                      "Are you sure you want to request to join this folder?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Yes"),
                      onPressed: () {
                        FolderService().requestToJoinFolder(
                            widget.snap["folderId"],
                            Provider.of<UserProvider>(context, listen: false)
                                .getUser
                                .uid,
                            Provider.of<UserProvider>(context, listen: false)
                                .getUser
                                .username);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      height: 100,
      width: 100,
    );
  }

  // folder screen has a list of all posts in the folder
  folderScreen({folderId, folderName, posts}) {
    // append '' to posts to avoid error
    posts.add('');
    return Scaffold(
        appBar: AppBar(
          title: Text(folderName),
          // list all posts in the folder using postCard widget
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where("postId", whereIn: posts)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.isEmpty) {
              return const Center(
                child: Text('No posts found'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data as dynamic).docs.length,
              itemBuilder: (ctx, index) =>
                  PostCard(snap: snapshot.data.docs[index].data()),
            );
          },
        ));
  }
}
