import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/reusable_widgets/position_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/side_nav_bar.dart';
import '../screens/explore_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapSampleState();
}

class MapSampleState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  TextEditingController _originController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Marker _marker = Marker(
    markerId: MarkerId('marker 1'),
    position: LatLng(37.43296265331129, -122.08832357078792),
    infoWindow: InfoWindow(
      title: 'hi',
      snippet: 'cool',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Search Place...'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final place = await PositionServices()
                            .getPlaceDetails(_originController.text);

                        //update camera position
                        _goToPlace(place['geometry']['location']['lat'],
                            place['geometry']['location']['lng']);
                      },
                      child: Text('Search Place...'))
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              markers: {_marker},
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));
  }
}
