import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Folder {
  final String uid;
  final String username;
  final String folderName;
  final String folderId;
  final List<dynamic> users;
  final List<dynamic> posts;
  final List<dynamic> requests;
  final int userCount;

  const Folder({
    @required this.uid,
    @required this.username,
    @required this.folderName,
    @required this.folderId,
    @required this.users,
    @required this.userCount,
    @required this.posts,
    @required this.requests,
  });

  static Folder fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Folder(
      uid: snapshot["uid"],
      username: snapshot["username"],
      folderName: snapshot["folderName"],
      folderId: snapshot["folderId"],
      users: snapshot["users"],
      userCount: snapshot["userCount"],
      posts: snapshot["posts"],
      requests: snapshot["requests"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "folderName": folderName,
        "folderId": folderId,
        "users": users,
        "userCount": userCount,
        "posts": posts,
        "requests": requests,
      };
}
