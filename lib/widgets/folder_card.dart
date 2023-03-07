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
    }  catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  adduser(String folderId, String uid, String username) async {
    try {
      await FireStoreMethods().addUserToFolder(folderId, uid, username);
    }  catch (err) {
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
