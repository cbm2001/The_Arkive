import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String name;
  final String photoUrl;
  final String bio;

  const User({
    @required this.username,
    @required this.uid,
    @required this.email,
    @required this.name,
    @required this.photoUrl,
    @required this.bio,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      name: snapshot['name'],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "name": name,
        "photoUrl": photoUrl,
        "bio": bio,
      };
}
