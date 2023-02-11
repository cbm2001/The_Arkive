import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as model;
import 'storage_methods.dart';
//import 'package:instagram_clone_flutter/models/user.dart' as model;
//import 'package:instagram_clone_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
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
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl;
        if (file == null) {
          photoUrl = 'https://i.stack.imgur.com/l60Hf.png';
        } else {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        }

        /*await _firestore.collection('Users').doc(cred.user.uid).set({
          'username': username,
          'uid': cred.user.uid,
          'email': email,
          'name': name,
          //'photoUrl': photoUrl,
        });*/

        model.User _user = model.User(
          username: username,
          uid: cred.user.uid,
          email: email,
          name: name,
          photoUrl: photoUrl,
          bio: bio,
        );

        // adding user in our database
        await _firestore
            .collection("Users")
            .doc(cred.user.uid)
            .set(_user.toJson());

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
        await _auth.signInWithEmailAndPassword(
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
}
