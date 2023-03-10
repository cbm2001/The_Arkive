import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/providers/user_provider.dart';
import 'package:first_app/widgets/like_animation.dart';
import 'package:first_app/screens/comment_screen.dart';
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
      await FireStoreMethods().addPostToFolder(folderId, postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  adduser(String folderId, String uid, String username) async {
    try {
      await FireStoreMethods().addUserToFolder(folderId, uid, username);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  deletepost(String folderId, String postId) {
    try {
      FireStoreMethods().removePostFromFolder(folderId, postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  deleteuser(String folderId, String uid, String username) {
    try {
      FireStoreMethods().removeUserFromFolder(folderId, uid, username);
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
                addpost: addpost,
                deletepost: deletepost,
                adduser: adduser,
                deleteuser: deleteuser,
              ),
            ),
          );
        },
        onLongPress: () {
          // if (widget.snap["users"] is in Provider.of<UserProvider>(context, listen: false).getUser.username then show delete button)
          if (widget.snap["users"].contains(
              Provider.of<UserProvider>(context, listen: false).getUser.uid)) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Delete folder"),
                  content: Text("Are you sure you want to delete this folder?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Yes"),
                      onPressed: () {
                        FireStoreMethods()
                            .deleteFolder(widget.snap["folderId"]);
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
          // else show request to join button if not already requested
          else if (widget.snap["requests"].contains(
              Provider.of<UserProvider>(context, listen: false).getUser.uid)) {
              showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Request to join"),
                  content: Text(
                      "You have already requested to join this folder"),
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
          }
          else {
            
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
                        FireStoreMethods().requestToJoinFolder(
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
}

folderScreen(
    {folderId,
    folderName,
    Function(String folderId, String postId) addpost,
    Function(String folderId, String postId) deletepost,
    Function(String folderId, String uid, String username) adduser,
    Function(String folderId, String uid, String username) deleteuser}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(folderName),
    ),
    body: Container(
      child: Column(
        children: [
          // show the names of the users in the folder
          StreamBuilder(
            stream: FireStoreMethods().getUsersInFolder(folderId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snap.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snap.data.documents[index];
                  return ListTile(
                    title: Text(user["username"]),
                    subtitle: Text(user["uid"]),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => folderScreen(
                      //       folderId: folder["folderId"],
                      //       folderName: folder["folderName"],
                      //       addpost: addpost,
                      //       deletepost: deletepost,
                      //       adduser: adduser,
                      //       deleteuser: deleteuser,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              );
            },
          ),
          // show the names of the posts in the folder
          StreamBuilder(
            stream: FireStoreMethods().getPostsInFolder(folderId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snap.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot post = snap.data.documents[index];
                  return ListTile(
                    title: Text(post["caption"]),
                    subtitle: Text(post["postId"]),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => folderScreen(
                      //       folderId: folder["folderId"],
                      //       folderName: folder["folderName"],
                      //       addpost: addpost,
                      //       deletepost: deletepost,
                      //       adduser: adduser,
                      //       deleteuser: deleteuser,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
