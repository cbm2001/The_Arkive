import 'dart:async';

// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
//import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:first_app/screens/post_draft_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPage extends StatefulWidget {
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ArCoreController _arKitController;
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
    var location = await Geolocator.getCurrentPosition();
    var currentLocation = LocationData.fromMap({
      "latitude": location.latitude,
      "longitude": location.longitude,
    });
    setState(() {
      _locationData = currentLocation;
    });
  }

  void _getPosts() async {
    var posts = await FirebaseFirestore.instance
        .collection('posts')
        // .where('location', isGreaterThan: _locationData.latitude - 0.1)
        // .where('location', isLessThan: _locationData.latitude + 0.1)
        .get();
    setState(() {
      _posts = posts.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _onARKitViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onARKitViewCreated(ArCoreController controller) {
    _arKitController = controller;
    _addMarkers();
    this._arKitController = _arKitController;
    final node = ArCoreNode(
      shape: ArCoreSphere(
        radius: 0.1,
        materials: [
          ArCoreMaterial(
            color: Colors.red,
            reflectance: 1,
          ),
        ],
      ),
      position: vector.Vector3(0, 0, -0.5),
    );
    this._arKitController.addArCoreNode(node);
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

            _arKitController.addArCoreNodeWithAnchor(ArCoreNode(
              shape: ArCoreSphere(
                radius: 0.1,
                materials: [
                  ArCoreMaterial(
                    color: Colors.red,
                    reflectance: 1,
                  ),
                ],
              ),
              position: vector.Vector3(lat, long, -0.5),
              rotation: vector.Vector4(0, 0, 0, 0),
            ));
          }
        }
      }
    });
  }
}
