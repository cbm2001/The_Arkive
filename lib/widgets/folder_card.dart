import 'dart:core';

import 'dart:core';

import 'dart:io';

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:first_app/models/folders.dart';

import 'package:first_app/providers/user_provider.dart';

import 'package:first_app/screens/profile_screen.dart';

import 'package:first_app/widgets/like_animation.dart';

import 'package:first_app/screens/comment_screen.dart';

import 'package:first_app/widgets/post_card.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:vector_math/vector_math.dart' as prefix;

import '../models/user.dart';

import '../resources/firestore_methods.dart';

import '../services/crud/notification_service.dart';
import '../utils/utils.dart';

class FolderCard extends StatefulWidget {
  final snap;

  const FolderCard({
    Key key,
    @required this.snap,
  }) : super(key: key);

  @override
  State<FolderCard> createState() => FolderCardState();
}

class FolderCardState extends State<FolderCard> {
  Image cover;

  Uint8List filee;

  bool coverSet;

  List<Image> covers = [];

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

  addCover() {
    FireStoreMethods().UploadCover(
      widget.snap["folderId"],
    );
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
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),

          // child: Column(

          //   // decoration: BoxDecoration(

          //   //   color: Colors.yellow[100],

          //   // ),

          //   children: [

          //     Image.network(

          //       widget.snap['cover'],

          //       fit: BoxFit.cover,),

          //     ],

          child: Card(
            elevation: 5,
            child: Container(
              color: Color.fromRGBO(192, 234, 240, 1),
              child: Row(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 7, 20, 7),
                      child: Container(
                        child: Image.network(
                          widget.snap['cover'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(192, 234, 240, 1),

                        foregroundColor: Colors.grey.shade700,

                        elevation: 0.0,

                        shadowColor: Colors.transparent,

                        minimumSize: Size.zero, // Set this

                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),

                        // textStyle:
                      ),
                      child: Text(
                        widget.snap["folderName"],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
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
                            Provider.of<UserProvider>(context, listen: false)
                                .getUser
                                .uid)) {
                          // show 3 options: delete folder, add user, remove user

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text("Folder options"),
                                ),

                                // content: Center(child:Text("What would you like to do?"),),

                                // Text("What would you like to do?"),

                                actions: <Widget>[
                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Delete folder"),
                                        onPressed: () {
                                          FireStoreMethods().deleteFolder(
                                              widget.snap["folderId"]);

                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(192, 234, 240, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
                                  ),

                                  Center(
                                    child: ElevatedButton(
                                      child: Text("Add user"),
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                        backgroundColor:
                                            Color.fromRGBO(192, 234, 240, 1),
                                        foregroundColor:
                                            Color.fromRGBO(139, 134, 134, 1),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);

                                        if (widget.snap["requests"].length >
                                            0) {
                                          // show list of requests with a checkbox next to each one and a button to add them

                                          List<bool> _checkboxStates =
                                              List.generate(
                                                  widget
                                                      .snap["requests"].length,
                                                  (index) => false);

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Center(
                                                    child: Text("Add user")),
                                                content: Container(
                                                  height: 300,
                                                  width: 300,
                                                  child: ListView.builder(
                                                    itemCount: widget
                                                        .snap["requests"]
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return FutureBuilder(
                                                        future: FireStoreMethods()
                                                            .getUser(widget
                                                                        .snap[
                                                                    "requests"]
                                                                [index]),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return ListTile(
                                                              title: Text(snapshot
                                                                      .data[
                                                                  "username"]),
                                                              trailing:
                                                                  ElevatedButton(
                                                                      child: Text(
                                                                          "Add"),
                                                                      onPressed:
                                                                          () {
                                                                        FireStoreMethods()
                                                                            .addUserToFolder(
                                                                          widget
                                                                              .snap["folderId"],
                                                                          snapshot
                                                                              .data["uid"],
                                                                          snapshot
                                                                              .data["username"],
                                                                        );

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        fixedSize: Size(
                                                                            MediaQuery.of(context).size.width *
                                                                                0.40,
                                                                            MediaQuery.of(context).size.height *
                                                                                0.04),
                                                                        backgroundColor: Color.fromRGBO(
                                                                            192,
                                                                            234,
                                                                            240,
                                                                            1),
                                                                        foregroundColor: Color.fromRGBO(
                                                                            139,
                                                                            134,
                                                                            134,
                                                                            1),
                                                                      )),
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.40,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.04),
                                                        backgroundColor:
                                                            Color.fromRGBO(232,
                                                                213, 235, 1),
                                                        foregroundColor:
                                                            Color.fromRGBO(139,
                                                                134, 134, 1),
                                                      )),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Center(
                                                    child: Text("Add User")),
                                                content: Text(
                                                    "There are no requests to add to this folder"),
                                                actions: <Widget>[
                                                  Center(
                                                    child: ElevatedButton(
                                                        child: Center(
                                                            child:
                                                                Text("Cancel")),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.40,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.04),
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  232,
                                                                  213,
                                                                  235,
                                                                  1),
                                                          foregroundColor:
                                                              Color.fromRGBO(
                                                                  139,
                                                                  134,
                                                                  134,
                                                                  1),
                                                        )),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  // remove user

                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Remove user"),
                                        onPressed: () {
                                          Navigator.pop(context);

                                          if (widget.snap["users"].length > 0) {
                                            // show list of users with a checkbox next to each one and a button to remove them

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                      child:
                                                          Text("Remove User")),
                                                  content: Container(
                                                    height: 300,
                                                    width: 300,
                                                    child: ListView.builder(
                                                      itemCount: widget
                                                          .snap["users"].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return FutureBuilder(
                                                          future: FireStoreMethods()
                                                              .getUser(widget
                                                                          .snap[
                                                                      "users"]
                                                                  [index]),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return ListTile(
                                                                title: Text(snapshot
                                                                        .data[
                                                                    "username"]),
                                                                trailing:
                                                                    ElevatedButton(
                                                                  child: Text(
                                                                      "Remove"),
                                                                  onPressed:
                                                                      () {
                                                                    FireStoreMethods()
                                                                        .removeUserFromFolder(
                                                                      widget.snap[
                                                                          "folderId"],
                                                                      snapshot.data[
                                                                          "uid"],
                                                                      snapshot.data[
                                                                          "username"],
                                                                    );

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    fixedSize: Size(
                                                                        MediaQuery.of(context).size.width *
                                                                            0.25,
                                                                        MediaQuery.of(context).size.height *
                                                                            0.04),
                                                                    backgroundColor:
                                                                        Color.fromRGBO(
                                                                            192,
                                                                            234,
                                                                            240,
                                                                            1),
                                                                    foregroundColor:
                                                                        Color.fromRGBO(
                                                                            139,
                                                                            134,
                                                                            134,
                                                                            1),
                                                                  ),
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
                                                    Center(
                                                      child: ElevatedButton(
                                                          child: Text("Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            fixedSize: Size(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.25,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.04),
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    232,
                                                                    213,
                                                                    235,
                                                                    1),
                                                            foregroundColor:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    134,
                                                                    134,
                                                                    1),
                                                          )),
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
                                                    Center(
                                                      child: ElevatedButton(
                                                          child: Text("Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            fixedSize: Size(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.40,
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.04),
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    232,
                                                                    213,
                                                                    235,
                                                                    1),
                                                            foregroundColor:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    134,
                                                                    134,
                                                                    1),
                                                          )),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(192, 234, 240, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
                                  ),

                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Change Cover"),
                                        onPressed: () async {
                                          coverSet = true;

                                          Navigator.of(context).pop();

                                          FireStoreMethods().UploadCover(
                                            widget.snap["folderId"],
                                          );

                                          // final ImagePicker _imagePicker = ImagePicker();

                                          // XFile _file = await _imagePicker.pickImage(

                                          //     source: ImageSource.gallery);

                                          // if (_file == null) return;

                                          // print('hi${_file?.path}');

                                          // Reference referenceRoot =

                                          //     FirebaseStorage.instance.ref();

                                          // Reference referenceDirImages =

                                          //     referenceRoot.child('images');

                                          // String uniqueFileName = DateTime.now()

                                          //     .millisecondsSinceEpoch

                                          //     .toString();

                                          // Reference referenceImageToUpload =

                                          //     referenceDirImages.child(uniqueFileName);

                                          // // try {

                                          //   await referenceImageToUpload

                                          //       .putFile(File(_file.path));

                                          //   imageURL = await referenceImageToUpload

                                          //       .getDownloadURL();

                                          //   print('vobjectobjectobjectobjectobjectobjectobjectobjectobject   ');

                                          //   print(imageURL);

                                          // } catch (error) {}

                                          // setState(() {

                                          //   coverSet = true;

                                          //   // cover = Image.memory(file);

                                          //   // covers.add(cover);

                                          // });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(192, 234, 240, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
                                  ),

                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(232, 213, 235, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        // else show request to join button if not already requested

                        else if (widget.snap["requests"].contains(
                            Provider.of<UserProvider>(context, listen: false)
                                .getUser
                                .uid)) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(child: Text("Request to join")),
                                content: Text(
                                    "You have already requested to join this folder"),
                                actions: <Widget>[
                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(192, 234, 240, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
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
                                title: Center(child: Text("Request to join")),
                                content: Text(
                                    "Are you sure you want to request to join this folder?"),
                                actions: <Widget>[
                                  Center(
                                    child: ElevatedButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        FireStoreMethods().requestToJoinFolder(
                                            widget.snap["folderId"],
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .getUser
                                                .uid,
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .getUser
                                                .username);

                                        NotificationService().addRequesttoNotif(
                                          widget.snap["folderId"],
                                          widget.snap['cover'].toString(),
                                          widget.snap['uid'],
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .getUser
                                              .username,
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .getUser
                                              .photoUrl
                                              .toString(),
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                        backgroundColor:
                                            Color.fromRGBO(192, 234, 240, 1),
                                        foregroundColor:
                                            Color.fromRGBO(139, 134, 134, 1),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          backgroundColor:
                                              Color.fromRGBO(192, 234, 240, 1),
                                          foregroundColor:
                                              Color.fromRGBO(139, 134, 134, 1),
                                        )),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ),
        ),
      ],
    );

    // ignore: dead_code

    //   height: 100;

    //   width: 100;

    // );
  }

  // folder screen has a list of all posts in the folder

  folderScreen({folderId, folderName, posts}) {
    // append '' to posts to avoid error

    posts.add('');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          foregroundColor: Colors.black,

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
