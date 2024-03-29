import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String location;
  final String category;
  final String profImage;
  // final double latitude;
  // final double longitude;
  final GeoPoint geoLoc;
  final bool flag;

  const Post(
      {@required this.description,
      @required this.uid,
      @required this.username,
      @required this.likes,
      @required this.postId,
      @required this.datePublished,
      @required this.postUrl,
      @required this.location,
      @required this.category,
      @required this.profImage,
      // @required this.latitude,
      // @required this.longitude,
      @required this.geoLoc,
      @required this.flag});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      location: snapshot['location'],
      category: snapshot['category'],
      profImage: snapshot['profImage'],
      // latitude: snapshot['latitude'],
      // longitude: snapshot['longitude']
      geoLoc: snapshot['geoLoc'],
      flag: false,
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'location': location,
        'category': category,
        // 'latitude': latitude,
        // 'longitude':longitude,
        'geoLoc': geoLoc,
        'flag':false

      };
}
