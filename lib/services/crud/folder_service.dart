//import 'dart:ffi';
//import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/folders.dart';

//import '/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FolderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createFolder(
      String folderName,
      String uid,
      String username,
      List<dynamic> posts,
      List<dynamic> users,
      int userCount,
      List<dynamic> requests) async {
    String res = "Some error occurred";
    try {
      String folderId = const Uuid().v1();
      Folder folder = Folder(
        folderName: folderName,
        folderId: folderId,
        uid: uid,
        username: username,
        users: users,
        posts: posts,
        userCount: userCount,
        requests: requests,
      );
      _firestore.collection('folders').doc(folderId).set(folder.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addPostToFolder(String folderId, String postId) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'posts': FieldValue.arrayUnion([postId])
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> removePostFromFolder(String folderId, String postId) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'posts': FieldValue.arrayRemove([postId])
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addUserToFolder(
      String folderId, String uid, String username) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'users': FieldValue.arrayUnion([uid]),
        'userCount': FieldValue.increment(1),
        // remove from requests
        'requests': FieldValue.arrayRemove([uid])
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> removeUserFromFolder(
      String folderId, String uid, String username) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'users': FieldValue.arrayRemove([uid]),
        'userCount': FieldValue.increment(-1),
      });
      // if count is 0, delete folder
      DocumentSnapshot snap =
          await _firestore.collection('folders').doc(folderId).get();
      int count = (snap.data() as dynamic)['userCount'];
      if (count == 0) {
        await _firestore.collection('folders').doc(folderId).delete();
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteFolder(String folderId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('folders').doc(folderId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> requestToJoinFolder(
      String folderId, String uid, String username) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'requests': FieldValue.arrayUnion([uid])
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> favoriteFolder(String folderId, String uid) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('folders').doc(folderId).update({
        'favorites': FieldValue.arrayUnion([uid])
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // folders has an attribute called users which is a list of uids, getfolder returns list of folders that can be accessed by the user
  Stream<List<Folder>> getFolders(String uid) {
    return FirebaseFirestore.instance
        .collection('folders')
        .where('users', arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Folder.fromJson(doc.data(), doc.id))
            .toList());
  }

  getUsersInFolder(folderId) {
    return FirebaseFirestore.instance
        .collection('folders')
        .doc(folderId)
        .get()
        .then((value) => value.data()['users']);
  }

  getUidFromUsername(String username) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .get()
        .then((value) => value.docs[0].id);
  }

  getPostsInFolder(folderId) {
    return FirebaseFirestore.instance
        .collection('folders')
        .doc(folderId)
        .get()
        .then((value) => value.data()['posts']);
  }

  getUser(snap) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(snap)
        .get()
        .then((value) => value.data());
  }

  getPost(post) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(post)
        .get()
        .then((value) => value.data());
  }
}
