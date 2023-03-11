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
                        FireStoreMethods()
                            .deleteFolder(widget.snap["folderId"]);
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
                                        future: FireStoreMethods().getUser(
                                            widget.snap["requests"][index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListTile(
                                              title: Text(
                                                  snapshot.data["username"]),
                                              trailing: ElevatedButton(
                                                child: Text("Add"),
                                                onPressed: () {
                                                  FireStoreMethods()
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
                        if (widget.snap["users"].length > 1) {
                          // show list of users with a checkbox next to each one and a button to remove them
                          List<bool> _checkboxStates = List.generate(
                              widget.snap["users"].length, (index) => false);

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
                                        future: FireStoreMethods().getUser(
                                            widget.snap["users"][index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListTile(
                                              title: Text(
                                                  snapshot.data["username"]),
                                              trailing: ElevatedButton(
                                                child: Text("Remove"),
                                                onPressed: () {
                                                  FireStoreMethods()
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
