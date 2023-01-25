import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Draft {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String location;
  final String category;
  final String profImage;
  final String latitude;
  final String longitude;

  const Draft({
    @required this.description,
    @required this.uid,
    @required this.username,
    @required this.postId,
    @required this.datePublished,
    @required this.postUrl,
    @required this.location,
    @required this.category,
    @required this.profImage,
    @required this.latitude,
    @required this.longitude,

  });

  static Draft fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Draft(
        description: snapshot["description"],
        uid: snapshot["uid"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        location: snapshot['location'],
        category: snapshot['category'],
        profImage: snapshot['profImage'],
        latitude: snapshot['latitude'],
        longitude: snapshot['longitude']
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'location': location,
    'category': category,
    'latitude': latitude,
    'longitude':longitude,
  };
}
