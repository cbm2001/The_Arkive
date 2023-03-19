import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:first_app/models/notif.dart';
import 'package:first_app/services/auth/firebase_auth_service.dart';

import 'package:uuid/uuid.dart';

class NotificationService {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addLiketoNotif(String postId, String uid, String username,
      String postUrl, String photoUrl) async {
    String res = "Some error occurred";
    String notifId = const Uuid().v1();
    bool isNotPostOwner = _auth.currentUser.uid != uid;
    if (isNotPostOwner) {
      try {
        NotificationItems item = NotificationItems(
            type: "likes",
            notifId: notifId,
            username: username, // User who liked the post
            userId: _auth.currentUser.uid, // owner id
            userProfile: photoUrl,
            postId: postId,
            postUrl: postUrl,
            timeStamp: Timestamp.now());
        _firestore
            .collection("notifications")
            .doc(uid)
            .collection("notifItems")
            .doc(notifId)
            .set(item.toJson());
        //if (FirebaseAuth.instance.currentUser.uid == uid) {}
      } catch (err) {
        res = err.toString();
      }
    }
    return res;
  }

  Future<String> removeLikefromNotif(String notifId, String uid) async {
    String res = "Some error occurred";
    bool isNotPostOwner = _auth.currentUser.uid != uid;
    if (isNotPostOwner) {
      try {
        _firestore
            .collection("notifications")
            .doc(uid)
            .collection("notifItems")
            .doc(notifId)
            .delete();
        res = "success";
        //if (FirebaseAuth.instance.currentUser.uid == uid) {}
      } catch (err) {
        res = err.toString();
      }
    }
    return res;
  }

  Future<String> removeNotif(String notifId, String uid) async {
    String res = "Some error occurred";
    //bool isNotPostOwner = FirebaseAuth.instance.currentUser.uid != uid;

    try {
      _firestore
          .collection("notifications")
          .doc(uid)
          .collection("notifItems")
          .doc(notifId)
          .delete();
      res = "success";
      //if (FirebaseAuth.instance.currentUser.uid == uid) {}
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> addCommenttoNotif(String postId, String uid, String username,
      String postUrl, String photoUrl, String text) async {
    String res = "Some error occurred";
    bool isNotPostOwner = _auth.currentUser.uid != uid;
    String notifId = const Uuid().v1();
    if (isNotPostOwner) {
      try {
        NotificationItems item = NotificationItems(
            type: "Comments",
            notifId: notifId,
            text: text,
            username: username, // User who liked the post
            userId: _auth.currentUser.uid, // user id
            userProfile: photoUrl,
            postId: postId,
            postUrl: postUrl,
            timeStamp: Timestamp.now());
        _firestore
            .collection("notifications")
            .doc(uid)
            .collection("notifItems")
            .doc(notifId)
            .set(item.toJson());
        //if (FirebaseAuth.instance.currentUser.uid == uid) {}
      } catch (err) {
        res = err.toString();
      }
    }
    return res;
  }

  Future<String> addRequesttoNotif(
      String folder, String folderUrl, String uid, String username, String photoUrl) async {
    String res = "Some error occurred";
    String notifId = const Uuid().v1();
    bool isNotFolderOwner = FirebaseAuth.instance.currentUser.uid != uid;
    if (isNotFolderOwner) {
      try {
        NotificationItems item = NotificationItems(
            type: "folders",
            folder: folder,
            folderUrl: folderUrl,
            notifId: notifId,
            username: username, // User who requested it
            userId: FirebaseAuth.instance.currentUser.uid, // owner id
            userProfile: photoUrl,
            timeStamp: Timestamp.now());
        _firestore
            .collection("notifications")
            .doc(uid) // owner id
            .collection("notifItems")
            .doc(notifId)
            .set(item.toJson());
        //if (FirebaseAuth.instance.currentUser.uid == uid) {}
      } catch (err) {
        res = err.toString();
      }
    }
    return res;
  }
}
