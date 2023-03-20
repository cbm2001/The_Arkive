import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/main.dart';
import 'package:first_app/screens/login_screen.dart';
import 'package:first_app/screens/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../widgets/post_card.dart';
import '../providers/user_provider.dart';
import 'notification.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      //extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        //centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text('Explore',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black, fontSize: 25, fontFamily: 'Comfortaa')),
        ),
        //titleSpacing: 20.0,
        //iconTheme: IconThemeData.fallback(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.circle_notifications_sharp),
            tooltip: 'Open shopping cart',
            color: Colors.amber,
            padding: EdgeInsets.only(top: 10.0),
            iconSize: 40,
            alignment: Alignment.center,
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewNotification(),
                ),
              );
            }),
          ),
        ],
      ),
      body:
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,

          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,

          StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) => Card(
              child: PostCard(snap: snapshot.data.docs[index].data()),
              elevation: 10,
            ),
          );
        },
      ),
      /*Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  child: MyNavigation()),*/
    );
  }
}

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NavitionState createState() => _NavitionState();
}

class _NavitionState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Notification",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Text("Notification Body"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
