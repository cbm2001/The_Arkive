//import 'dart:ffi';
//import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/folders.dart';

//import '/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import 'dart:core';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FolderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  XFile fil;
  String imageURL = '';

  Future<void> uploadCover(String folderId) async {
    final ImagePicker _imagePicker = ImagePicker();
    fil = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (fil == null) return;
    print('hi${fil?.path}');
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(fil.path));
      imageURL = await referenceImageToUpload.getDownloadURL();
      _firestore.collection('folders').doc(folderId).update({
        'cover': imageURL,
      });
    } catch (error) {}
    print(imageURL);
  }

  isCover() {
    if (fil == null) return false;
    if (fil != null) return true;
  }

  Future<String> createFolder(
      String folderName,
      String uid,
      String username,
      List<dynamic> posts,
      List<dynamic> users,
      int userCount,
      String imageURL,
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
        cover: imageURL,
      );
      _firestore.collection('folders').doc(folderId).set(folder.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//   uploadCover() async {
//     final _firebaseStorage = FirebaseStorage.instance;
//     final _imagePicker = ImagePicker();
//     PickedFile image;
//     await Permission.photos.request();
// var permissionStatus = await Permission.photos.status;
//   }

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
    return _firestore
        .collection('folders')
        .where('users', arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Folder.fromJson(doc.data(), doc.id))
            .toList());
  }

  getUsersInFolder(folderId) {
    return _firestore
        .collection('folders')
        .doc(folderId)
        .get()
        .then((value) => value.data()['users']);
  }

  getUidFromUsername(String username) {
    return _firestore
        .collection('Users')
        .where('username', isEqualTo: username)
        .get()
        .then((value) => value.docs[0].id);
  }

  getPostsInFolder(folderId) {
    return _firestore
        .collection('folders')
        .doc(folderId)
        .get()
        .then((value) => value.data()['posts']);
  }

  getUser(snap) {
    return _firestore
        .collection('Users')
        .doc(snap)
        .get()
        .then((value) => value.data());
  }

  getPost(post) {
    return _firestore
        .collection('posts')
        .doc(post)
        .get()
        .then((value) => value.data());
  }
}
