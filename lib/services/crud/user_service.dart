import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/auth_user.dart';
import 'package:first_app/models/user.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/services/auth/firebase_auth_service.dart';
import 'package:first_app/services/crud/firebase_storage_service.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//import 'package:instagram_clone_flutter/models/user.dart' as model;
//import 'package:instagram_clone_flutter/resources/storage_methods.dart';

class UserService {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user details
  Future<User> getUserDetails() async {
    AuthUser currentUser = _auth.currentUser;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    return User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    @required String email,
    @required String password,
    @required String username,
    @required String name,
    @required String bio,
    @required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        AuthUser user = await _auth.createUser(
          email: email,
          password: password,
        );
        String photoUrl;
        if (file == null) {
          photoUrl = 'https://i.stack.imgur.com/l60Hf.png';
        } else {
          photoUrl = await FirebaseStorageService()
              .uploadImageToStorage('profilePics', file, false);
        }

        /*await _firestore.collection('Users').doc(cred.user.uid).set({
          'username': username,
          'uid': cred.user.uid,
          'email': email,
          'name': name,
          //'photoUrl': photoUrl,
        });*/

        User _user = User(
          username: username,
          uid: user.uid,
          email: email,
          name: name,
          photoUrl: photoUrl,
          bio: bio,
        );

        // await _firestore
        //     .collection("folders")
        //     .doc(cred.folderId)
        //     .set(_user.toJson());

        // adding user in our database
        await _firestore.collection("Users").doc(user.uid).set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    @required String email,
    @required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signIn(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
