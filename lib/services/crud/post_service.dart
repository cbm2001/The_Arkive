import 'dart:ffi';
import 'dart:typed_data';
import 'package:first_app/admin/analytics.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/drafts.dart';
import 'package:first_app/models/post.dart';
import 'package:first_app/services/crud/firebase_storage_service.dart';

//import '../models/folders.dart';
//import '/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();

  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String location,
      String category,
      String profImage,
      // double latitude,
      // double longitude
      GeoPoint geoLoc) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await _storage.uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          location: location,
          category: category,
          profImage: profImage,
          // longitude: longitude,
          // latitude: latitude
          geoLoc: geoLoc,
          flag: false);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
      checkDoc();
      await addPost();
      print("heloo");
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Future<String> uploadDraftPost(String description,
  //
  //       String uid,
  //       String username,
  //       String location,
  //       String category,
  //       String profImage,
  //   String postURL,
  //   String description,
  //   String location
  //   String category,
  //   String latitude,
  //   String longitude,) async{
  //   String res = "Some error occurred";
  //   try {
  //
  //     String postId = const Uuid().v1(); // creates unique id based on time
  //     Draft draft = Draft(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: PostURL,
  //       location: location,
  //       category: category,
  //       profImage: profImage,
  //     );
  //     _firestore.collection('drafts').doc(postId).set(draft.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  //
  // }

  Future<String> uploadDraft(
      String description,
      Uint8List file,
      String uid,
      String username,
      String location,
      String category,
      String profImage,
      // double latitude,
      // double longitude
      GeoPoint geoLoc) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await _storage.uploadImageToStorage('drafts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Draft draft = Draft(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        location: location,
        category: category,
        profImage: profImage,
        geoLoc: geoLoc,
      );
      _firestore.collection('drafts').doc(postId).set(draft.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      /*if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } */
      //{
      // else we need to add uid to the likes array
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
      //addLiketoNotif(postId, uid, username, postUrl);

      //}
      res = 'success';
      checkDoc();
      await addLike();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> unlikePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      //if (likes.contains(uid)) {
      // if the likes list contains the user uid, we need to remove it
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
      /*} else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        //addLiketoNotif(postId, uid, username, postUrl);
      }*/
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
        checkDoc();
        await addComment();
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deleteDraft(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('drafts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  uploadDraftPost(
      String description,
      String postURL,
      String uid,
      String username,
      String location,
      String category,
      String profImage,
      // double latitude,
      // double longitude
      GeoPoint geoLoc,
      bool flag) async {
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: postURL,
          location: location,
          category: category,
          profImage: profImage,
          // longitude: longitude,
          // latitude: latitude
          geoLoc: geoLoc,
          flag: false);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
