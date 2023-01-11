import 'package:flutter/material.dart';
import '../models/side_nav_bar.dart';
import '../screens/explore_screen.dart';

class MapPage extends StatelessWidget {
  //const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          //backgroundColor: Color.fromRGBO(211, 211, 211, 1),

          backgroundColor: Colors.white,
          elevation: 0, iconTheme: IconThemeData.fallback(),
          /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
        ),*/
        /*appBar: AppBar(
          //backgroundColor: Color.fromRGBO(211, 211, 211, 1),
          backgroundColor: Colors.amber,
          elevation: 0,
          iconTheme: IconThemeData.fallback(),
          /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
        ),*/
        body: Container(
          width: MediaQuery.of(context).size.width,
          //width: double.infinity,
          height: MediaQuery.of(context).size.height,

          child: Column(
            children: <Widget>[
              //SizedBox(height: 20),
              Text(
                'Map',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              /*SizedBox(
                child: MyNavigationBar(),
                height: 585,
              ),*/
            ],
          ),
        ));
  }
}
