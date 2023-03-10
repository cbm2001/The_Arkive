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

  createfolder(BuildContext parentContext) async {
    String folderName;
    return showDialog(
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: Text("Create a new folder"),
            content: TextField(
              decoration: InputDecoration(hintText: "Folder name"),
              onChanged: (value) {
                folderName = value;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Create"),
                onPressed: () {
                  FireStoreMethods().createFolder(
                    folderName,
                    Provider.of<UserProvider>(context, listen: false)
                        .getUser
                        .uid,
                    Provider.of<UserProvider>(context, listen: false)
                        .getUser
                        .username,
                    // create an empty list for posts
                    [],
                    // create an list with uid
                    [
                      Provider.of<UserProvider>(context, listen: false)
                          .getUser
                          .uid
                    ],
                    1,
                    // create an empty list for requests
                    [],
                  );
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // create a button to create a new folder

    return Container(

        // child: ElevatedButton(
        //   onPressed: () {
        //     createfolder(context);
        //   },
        //   child: Text("create folder"),
        // ),
        // show the names of the folders in a list
        child: StreamBuilder(
        
          stream: FireStoreMethods().getFolders(
            Provider.of<UserProvider>(context, listen: false).getUser.uid,
          ),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator()
              );
            }
            
            return ListView.builder(
              itemCount: snap.data.documents.length,
              // print itemCount to see if it is working

              itemBuilder: (context, index) {
                DocumentSnapshot folder = snap.data.documents[index];
                return ListTile(
                  title: Text(folder["folderName"]),
                  subtitle: Text(folder["userCount"].toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => folderScreen(
                          folderId: folder["folderId"],
                          folderName: folder["folderName"],
                          addpost: addpost,
                          deletepost: deletepost,
                          adduser: adduser,
                          deleteuser: deleteuser,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        height: 100,
        width: 100);
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
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot user = snapshot.data.documents[index];
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
}
