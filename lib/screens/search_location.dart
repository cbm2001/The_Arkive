import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/resources/locationMethods.dart';
import 'package:first_app/screens/post_draft_screen.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:first_app/widgets/position_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/side_nav_bar.dart';
import '../utils/utils.dart';
import 'explore_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapSearchPage extends StatefulWidget {
  GeoPoint gp;
  MapSearchPage({Key key,this.gpVal}) : super(key: key);
  Function (GeoPoint val) gpVal;

  @override
  State<MapSearchPage> createState() => MapSampleState();
}

class MapSampleState extends State<MapSearchPage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  TextEditingController _originController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  Set<Marker> _listMarkers={};
  int i=0;

  Set<Marker> addMarker(String username,double lat , double long){

    setState(() {
      i++;
      _listMarkers.add(Marker(
        markerId: MarkerId('marker ' + i.toString()),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
            title: "$username 's scrapbook",
            snippet: 'cool',
            onTap: (){
              return Scaffold();

            }
        ),
      ));
    });
    return _listMarkers;
  }
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
              markers: _listMarkers,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

              },
              onTap: _setMarker,
            ),

          ),
          ElevatedButton(
              onPressed: ()  {

                Navigator.pop(context);
                showSnackBar(context, "location tagged!");
              },
              child: Text('Select Tag'))

        ],
      ),
    );
  }
  _setMarker(LatLng currPoint){
    setState(() {
      _listMarkers = {};
      _listMarkers.add(
        Marker(markerId: MarkerId("Marker"),
        position: currPoint,));
      widget.gpVal(new GeoPoint(currPoint.latitude, currPoint.longitude));

    });
    print("this-----");
    print(currPoint);
  }
  Future<void> _goToPlace(double lat, double lng) async {
    addMarker("Current Location",lat,lng);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)))
    ;
    _setMarker(LatLng(lat, lng));






  }








}
