import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/resources/firestore_methods.dart';
import 'dart:io';

void main() {
  test('example test', () {
    expect(1+1, 2);
  });

  group('FireStoreMethods test', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    FireStoreMethods fireStoreMethods;
    FirebaseApp app;
    setUpAll(() async {
      app = await Firebase.initializeApp();
      fireStoreMethods = FireStoreMethods();
    });

    test('uploadPost', () async {
      String description = 'Test description';
      File file = File('/test/8a1bdf8266f9a2d01d583c4c6dc17765.png');
      Uint8List fileBytes = await file.readAsBytesSync();
      String uid = '6VMj7t30QTfifDTOYfszxZUO7p73';
      String username = 'poi';
      String location = 'Test location';
      String category = 'lifestyle';
      String profImage =
          'https://firebasestorage.googleapis.com/v0/b/my-app-73197.appspot.com/o/profilePics%2FynEiyELXQAclMETFPPWBdd4e3Xo1?alt=media&token=b670c039-3637-4977-9834-195bb5e1f0a6';
      GeoPoint geoLoc = GeoPoint(0, 0);
      String result = await fireStoreMethods.uploadPost(description, fileBytes,
          uid, username, location, category, profImage, geoLoc);
      expect(result, 'success');
    });

    test('uploadDraft', () async {
      String description = 'Test description';
      File file = File('/test/8a1bdf8266f9a2d01d583c4c6dc17765.png');
      Uint8List fileBytes = await file.readAsBytesSync();
      String uid = '6VMj7t30QTfifDTOYfszxZUO7p73';
      String username = 'poi';
      String location = 'Test location';
      String category = 'lifestyle';
      String profImage =
          'https://firebasestorage.googleapis.com/v0/b/my-app-73197.appspot.com/o/profilePics%2FynEiyELXQAclMETFPPWBdd4e3Xo1?alt=media&token=b670c039-3637-4977-9834-195bb5e1f0a6';
      GeoPoint geoLoc = GeoPoint(0, 0);
      String result = await fireStoreMethods.uploadDraft(description, fileBytes,
          uid, username, location, category, profImage, geoLoc);
      expect(result, 'success');
    });
  });
}
