import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../models/side_nav_bar.dart';
import 'explore_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:camera/camera.dart';

class ARPage extends StatefulWidget {
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ARKitController _arKitController;
  LocationData _locationData;
  List<DocumentSnapshot> _posts = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getPosts();
  }

  @override
  void dispose() {
    _arKitController.dispose();
    super.dispose();
  }

  void _getLocation() async {
    var location = Location();
    var currentLocation = await location.getLocation();
    setState(() {
      _locationData = currentLocation;
    });
  }

  void _getPosts() async {
    var posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('location', isGreaterThan: _locationData.latitude - 0.1)
        .where('location', isLessThan: _locationData.latitude + 0.1)
        .get();
    setState(() {
      _posts = posts.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(
        onARKitViewCreated: _onARKitViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onARKitViewCreated(ARKitController controller) {
    _arKitController = controller;
    _addMarkers();
    // this._arKitController = _arKitController;
    // final node = ARKitNode(
    //     geometry: ARKitSphere(radius: 0.1), position: vector.Vector3(0, 0, -0.5));
    // this._arKitController.add(node);
  }

  void _addMarkers() {
    FirebaseFirestore.instance.collection("posts").get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          print("see this");
          print(docs.docs[i].data()['geoLoc']);
          if (docs.docs[i].data()['geoLoc'] != null) {
            var geoLoc = docs.docs[i].data()['geoLoc'];
            var lat = geoLoc.latitude;
            var long = geoLoc.longitude;

            _arKitController.add(
              ARKitNode(
                position: vector.Vector3(lat, long, -0.5),
                geometry: ARKitSphere(
                  radius: 0.01,
                  materials: [
                    ARKitMaterial(
                      diffuse: ARKitMaterialProperty.color(Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    });
  }
}
