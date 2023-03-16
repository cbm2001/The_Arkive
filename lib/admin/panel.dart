import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/admin/dashboard.dart';
import 'package:first_app/admin/reported.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class panel extends StatefulWidget {
  const panel({Key key}) : super(key: key);

  @override
  State<panel> createState() => _panelState();
}

class _panelState extends State<panel> {
  QuerySnapshot numPosts = null ;
  int posts = 0;
  QuerySnapshot numUsers = null ;
  int users = 0;
  getAnalytics() async {
    numPosts = await FirebaseFirestore.instance.collection('posts').get();

    numUsers = await FirebaseFirestore.instance.collection('Users').get();

    setState(() {
      posts = numPosts.size;
      users = numUsers.size;
    });

}

  @override
  Widget build(BuildContext context) {
    getAnalytics();
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              children: [tile1("Total Posts", posts),tile1("Total Users", users)],),
              tile("Dashboard", Icon(Icons.analytics_outlined,size: 150,), dashboard()),
              tile("Reported Posts", Icon(Icons.report,size: 150,),reportedPosts())
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(String label, Icon Value, Widget page){
    return SizedBox(
      width: 250,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(

          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Text(label,textAlign: TextAlign.center,style: kLabelTextStyle,),
                SizedBox(height: 10,),
                SizedBox(child: Value,)
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(10.0),
            ),

            width: 250,
            height: 250,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => page),
            );
          },
        ),
      ),
    );
  }

  Widget tile1(String label, dynamic Value){
    return SizedBox(
      width: 190,
      height: 190,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(

          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Text(label,textAlign: TextAlign.center,style: kLabelTextStyle,),
                SizedBox(height: 10,),
                Text(Value.toString(),style: kNumberTextStyle,textAlign: TextAlign.center,)
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(10.0),
            ),

            width: 190,
            height: 190,
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }
}
