// import 'dart:core';
// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:first_app/admin/analytics.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:first_app/models/notif.dart';
// import 'package:first_app/screens/notification.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';

// import '../screens/post_screen.dart';
// import '../models/post.dart';
// import '../models/drafts.dart';
// import '../models/folders.dart';
// import '/resources/storage_methods.dart';
// import 'package:uuid/uuid.dart';

// class FireStoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> uploadPost(
//       String description,
//       Uint8List file,
//       String uid,
//       String username,
//       String location,
//       String category,
//       String profImage,
//       // double latitude,
//       // double longitude
//       GeoPoint geoLoc) async {
//     // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
//     String res = "Some error occurred";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage('posts', file, true);
//       String postId = const Uuid().v1(); // creates unique id based on time
//       Post post = Post(
//           description: description,
//           uid: uid,
//           username: username,
//           likes: [],
//           postId: postId,
//           datePublished: DateTime.now(),
//           postUrl: photoUrl,
//           location: location,
//           category: category,
//           profImage: profImage,
//           // longitude: longitude,
//           // latitude: latitude
//           geoLoc: geoLoc,
//           flag: false);
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//       checkDoc();
//       await addPost();
//       print("heloo");
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // Future<String> uploadDraftPost(String description,
//   //
//   //       String uid,
//   //       String username,
//   //       String location,
//   //       String category,
//   //       String profImage,
//   //   String postURL,
//   //   String description,
//   //   String location
//   //   String category,
//   //   String latitude,
//   //   String longitude,) async{
//   //   String res = "Some error occurred";
//   //   try {
//   //
//   //     String postId = const Uuid().v1(); // creates unique id based on time
//   //     Draft draft = Draft(
//   //       description: description,
//   //       uid: uid,
//   //       username: username,
//   //       postId: postId,
//   //       datePublished: DateTime.now(),
//   //       postUrl: PostURL,
//   //       location: location,
//   //       category: category,
//   //       profImage: profImage,
//   //     );
//   //     _firestore.collection('drafts').doc(postId).set(draft.toJson());
//   //     res = "success";
//   //   } catch (err) {
//   //     res = err.toString();
//   //   }
//   //   return res;
//   //
//   // }
//   XFile fil;
//   String imageURL = '';
//   UploadCover(String folderId) async {
//     final ImagePicker _imagePicker = ImagePicker();
//     fil = await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (fil == null) return;
//     print('hi${fil?.path}');
//     Reference referenceRoot = FirebaseStorage.instance.ref();
//     Reference referenceDirImages = referenceRoot.child('images');
//     String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
//     try {
//       await referenceImageToUpload.putFile(File(fil.path));
//       imageURL = await referenceImageToUpload.getDownloadURL();
//       _firestore.collection('folders').doc(folderId).update({
//         'cover': imageURL,
//       });
//     } catch (error) {}
//     print(imageURL);
//   }

//   isCover() {
//     if (fil == null) return false;
//     if (fil != null) return true;
//   }

//   Future<String> uploadDraft(
//       String description,
//       Uint8List file,
//       String uid,
//       String username,
//       String location,
//       String category,
//       String profImage,
//       // double latitude,
//       // double longitude
//       GeoPoint geoLoc) async {
//     // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
//     String res = "Some error occurred";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage('drafts', file, true);
//       String postId = const Uuid().v1(); // creates unique id based on time
//       Draft draft = Draft(
//         description: description,
//         uid: uid,
//         username: username,
//         postId: postId,
//         datePublished: DateTime.now(),
//         postUrl: photoUrl,
//         location: location,
//         category: category,
//         profImage: profImage,
//         geoLoc: geoLoc,
//       );
//       _firestore.collection('drafts').doc(postId).set(draft.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> likePost(String postId, String uid, List likes) async {
//     String res = "Some error occurred";
//     try {
//       /*if (likes.contains(uid)) {
//         // if the likes list contains the user uid, we need to remove it
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayRemove([uid])
//         });
//       } */
//       //{
//       // else we need to add uid to the likes array
//       _firestore.collection('posts').doc(postId).update({
//         'likes': FieldValue.arrayUnion([uid])
//       });
//       //addLiketoNotif(postId, uid, username, postUrl);

//       //}
//       res = 'success';
//       checkDoc();
//       await addLike();
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> unlikePost(String postId, String uid, List likes) async {
//     String res = "Some error occurred";
//     try {
//       //if (likes.contains(uid)) {
//       // if the likes list contains the user uid, we need to remove it
//       _firestore.collection('posts').doc(postId).update({
//         'likes': FieldValue.arrayRemove([uid])
//       });
//       /*} else {
//         // else we need to add uid to the likes array
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayUnion([uid])
//         });
//         //addLiketoNotif(postId, uid, username, postUrl);
//       }*/
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> addLiketoNotif(String postId, String uid, String username,
//       String postUrl, String photoUrl) async {
//     String res = "Some error occurred";
//     String notifId = const Uuid().v1();
//     bool isNotPostOwner = FirebaseAuth.instance.currentUser.uid != uid;
//     if (isNotPostOwner) {
//       try {
//         NotificationItems item = NotificationItems(
//             type: "likes",
//             notifId: notifId,
//             username: username, // User who liked the post
//             userId: FirebaseAuth.instance.currentUser.uid, // owner id
//             userProfile: photoUrl,
//             postId: postId,
//             postUrl: postUrl,
//             timeStamp: Timestamp.now());
//         _firestore
//             .collection("notifications")
//             .doc(uid)
//             .collection("notifItems")
//             .doc(notifId)
//             .set(item.toJson());
//         //if (FirebaseAuth.instance.currentUser.uid == uid) {}
//       } catch (err) {
//         res = err.toString();
//       }
//     }
//     return res;
//   }

//   Future<String> removeLikefromNotif(String notifId, String uid) async {
//     String res = "Some error occurred";
//     bool isNotPostOwner = FirebaseAuth.instance.currentUser.uid != uid;
//     if (isNotPostOwner) {
//       try {
//         _firestore
//             .collection("notifications")
//             .doc(uid)
//             .collection("notifItems")
//             .doc(notifId)
//             .delete();
//         res = "success";
//         //if (FirebaseAuth.instance.currentUser.uid == uid) {}
//       } catch (err) {
//         res = err.toString();
//       }
//     }
//     return res;
//   }

//   Future<String> removeNotif(String notifId, String uid) async {
//     String res = "Some error occurred";
//     //bool isNotPostOwner = FirebaseAuth.instance.currentUser.uid != uid;

//     try {
//       _firestore
//           .collection("notifications")
//           .doc(uid)
//           .collection("notifItems")
//           .doc(notifId)
//           .delete();
//       res = "success";
//       //if (FirebaseAuth.instance.currentUser.uid == uid) {}
//     } catch (err) {
//       res = err.toString();
//     }

//     return res;
//   }

//   // Post comment
//   Future<String> postComment(String postId, String text, String uid,
//       String name, String profilePic) async {
//     String res = "Some error occurred";
//     try {
//       if (text.isNotEmpty) {
//         // if the likes list contains the user uid, we need to remove it
//         String commentId = const Uuid().v1();
//         _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .doc(commentId)
//             .set({
//           'profilePic': profilePic,
//           'name': name,
//           'uid': uid,
//           'text': text,
//           'commentId': commentId,
//           'datePublished': DateTime.now(),
//         });
//         res = 'success';
//         checkDoc();
//         await addComment();
//       } else {
//         res = "Please enter text";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> addCommenttoNotif(String postId, String uid, String username,
//       String postUrl, String photoUrl, String text) async {
//     String res = "Some error occurred";
//     bool isNotPostOwner = FirebaseAuth.instance.currentUser.uid != uid;
//     String notifId = const Uuid().v1();
//     if (isNotPostOwner) {
//       try {
//         NotificationItems item = NotificationItems(
//             type: "Comments",
//             notifId: notifId,
//             text: text,
//             username: username, // User who liked the post
//             userId: FirebaseAuth.instance.currentUser.uid, // user id
//             userProfile: photoUrl,
//             postId: postId,
//             postUrl: postUrl,
//             timeStamp: Timestamp.now());
//         _firestore
//             .collection("notifications")
//             .doc(uid)
//             .collection("notifItems")
//             .doc(notifId)
//             .set(item.toJson());
//         //if (FirebaseAuth.instance.currentUser.uid == uid) {}
//       } catch (err) {
//         res = err.toString();
//       }
//     }
//     return res;
//   }

//   /*Future<String> deleteComment(String postId, String text, String uid,
//       String name, String profilePic) async {
//     String res = "Some error occurred";
//     try {
//       if (text.isNotEmpty) {
//         // if the likes list contains the user uid, we need to remove it
//         String commentId = const Uuid().v1();
//         _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .doc(commentId)
//             .set({
//           'profilePic': profilePic,
//           'name': name,
//           'uid': uid,
//           'text': text,
//           'commentId': commentId,
//           'datePublished': DateTime.now(),
//         });
//         res = 'success';
//       } else {
//         res = "Please enter text";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }*/

//   /*Future<String> deleteComment(String postId, String text, String uid,
//       String name, String profilePic) async {
//     String res = "Some error occurred";
//     try {
//       if (text.isNotEmpty) {
//         // if the likes list contains the user uid, we need to remove it
//         String commentId = const Uuid().v1();
//         _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .doc(commentId)
//             .set({
//           'profilePic': profilePic,
//           'name': name,
//           'uid': uid,
//           'text': text,
//           'commentId': commentId,
//           'datePublished': DateTime.now(),
//         });
//         res = 'success';
//       } else {
//         res = "Please enter text";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }*/

//   // Delete Post
//   Future<String> deletePost(String postId) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore.collection('posts').doc(postId).delete();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // Delete Post
//   Future<String> deleteDraft(String postId) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore.collection('drafts').doc(postId).delete();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<void> followUser(String uid, String followId) async {
//     try {
//       DocumentSnapshot snap =
//           await _firestore.collection('Users').doc(uid).get();
//       List following = (snap.data() as dynamic)['following'];

//       if (following.contains(followId)) {
//         await _firestore.collection('Users').doc(followId).update({
//           'followers': FieldValue.arrayRemove([uid])
//         });

//         await _firestore.collection('Users').doc(uid).update({
//           'following': FieldValue.arrayRemove([followId])
//         });
//       } else {
//         await _firestore.collection('Users').doc(followId).update({
//           'followers': FieldValue.arrayUnion([uid])
//         });

//         await _firestore.collection('Users').doc(uid).update({
//           'following': FieldValue.arrayUnion([followId])
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   uploadDraftPost(
//       String description,
//       String postURL,
//       String uid,
//       String username,
//       String location,
//       String category,
//       String profImage,
//       // double latitude,
//       // double longitude
//       GeoPoint geoLoc,
//       bool flag) async {
//     String res = "Some error occurred";
//     try {
//       String postId = const Uuid().v1(); // creates unique id based on time
//       Post post = Post(
//           description: description,
//           uid: uid,
//           username: username,
//           likes: [],
//           postId: postId,
//           datePublished: DateTime.now(),
//           postUrl: postURL,
//           location: location,
//           category: category,
//           profImage: profImage,
//           // longitude: longitude,
//           // latitude: latitude
//           geoLoc: geoLoc,
//           flag: false);
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> createFolder(
//       String folderName,
//       String uid,
//       String username,
//       List<dynamic> posts,
//       List<dynamic> users,
//       int userCount,
//       String imageURL,
//       List<dynamic> requests) async {
//     String res = "Some error occurred";
//     try {
//       String folderId = const Uuid().v1();
//       Folder folder = Folder(
//         folderName: folderName,
//         folderId: folderId,
//         uid: uid,
//         username: username,
//         users: users,
//         posts: posts,
//         userCount: userCount,
//         requests: requests,
//         cover: imageURL,
//       );
//       _firestore.collection('folders').doc(folderId).set(folder.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

// //   uploadCover() async {
// //     final _firebaseStorage = FirebaseStorage.instance;
// //     final _imagePicker = ImagePicker();
// //     PickedFile image;
// //     await Permission.photos.request();
// // var permissionStatus = await Permission.photos.status;
// //   }

//   Future<String> addPostToFolder(String folderId, String postId) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'posts': FieldValue.arrayUnion([postId])
//       });
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> removePostFromFolder(String folderId, String postId) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'posts': FieldValue.arrayRemove([postId])
//       });
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> addUserToFolder(
//       String folderId, String uid, String username) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'users': FieldValue.arrayUnion([uid]),
//         'userCount': FieldValue.increment(1),
//         // remove from requests
//         'requests': FieldValue.arrayRemove([uid])
//       });
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> removeUserFromFolder(
//       String folderId, String uid, String username) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'users': FieldValue.arrayRemove([uid]),
//         'userCount': FieldValue.increment(-1),
//       });
//       // if count is 0, delete folder
//       DocumentSnapshot snap =
//           await _firestore.collection('folders').doc(folderId).get();
//       int count = (snap.data() as dynamic)['userCount'];
//       if (count == 0) {
//         await _firestore.collection('folders').doc(folderId).delete();
//       }
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> deleteFolder(String folderId) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore.collection('folders').doc(folderId).delete();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> requestToJoinFolder(
//       String folderId, String uid, String username) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'requests': FieldValue.arrayUnion([uid])
//       });
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> addRequesttoNotif(
//       String folder, String uid, String username, String photoUrl) async {
//     String res = "Some error occurred";
//     String notifId = const Uuid().v1();
//     bool isNotFolderOwner = FirebaseAuth.instance.currentUser.uid != uid;
//     if (isNotFolderOwner) {
//       try {
//         NotificationItems item = NotificationItems(
//             type: "folders",
//             folder: folder,
//             notifId: notifId,
//             username: username, // User who requested it
//             userId: FirebaseAuth.instance.currentUser.uid, // owner id
//             userProfile: photoUrl,
//             timeStamp: Timestamp.now());
//         _firestore
//             .collection("notifications")
//             .doc(uid) // owner id
//             .collection("notifItems")
//             .doc(notifId)
//             .set(item.toJson());
//         //if (FirebaseAuth.instance.currentUser.uid == uid) {}
//       } catch (err) {
//         res = err.toString();
//       }
//     }
//     return res;
//   }

//   Future<String> favoriteFolder(String folderId, String uid) async {
//     String res = "Some error occurred";
//     try {
//       _firestore.collection('folders').doc(folderId).update({
//         'favorites': FieldValue.arrayUnion([uid])
//       });
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // folders has an attribute called users which is a list of uids, getfolder returns list of folders that can be accessed by the user
//   Stream<List<Folder>> getFolders(String uid) {
//     return FirebaseFirestore.instance
//         .collection('folders')
//         .where('users', arrayContains: uid)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Folder.fromJson(doc.data(), doc.id))
//             .toList());
//   }

//   getUsersInFolder(folderId) {
//     return FirebaseFirestore.instance
//         .collection('folders')
//         .doc(folderId)
//         .get()
//         .then((value) => value.data()['users']);
//   }

//   getUidFromUsername(String username) {
//     return FirebaseFirestore.instance
//         .collection('Users')
//         .where('username', isEqualTo: username)
//         .get()
//         .then((value) => value.docs[0].id);
//   }

//   getPostsInFolder(folderId) {
//     return FirebaseFirestore.instance
//         .collection('folders')
//         .doc(folderId)
//         .get()
//         .then((value) => value.data()['posts']);
//   }

//   getUser(snap) {
//     return FirebaseFirestore.instance
//         .collection('Users')
//         .doc(snap)
//         .get()
//         .then((value) => value.data());
//   }

//   getPost(post) {
//     return FirebaseFirestore.instance
//         .collection('posts')
//         .doc(post)
//         .get()
//         .then((value) => value.data());
//   }
// }
