import 'dart:typed_data';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../auth/firebase_auth_service.dart';
//import 'package:flutter/foundation.dart';
//import 'package:uuid/uuid.dart';

class StorageService {
  final AuthService _auth = AuthService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser.uid);

    if (isPost) {
      //creating a unique id for each post under a user
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future shiftDraftToPost(
      String childName, String PostURL, bool isPost) async {}
}
