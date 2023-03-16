import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'constants.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  var analyticsSnap;
  var analyticsSnapData={};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String nowDate = DateTime.now().day.toString()+ "-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
    print("////////");
    print(nowDate);

    try{
      analyticsSnap = await FirebaseFirestore.instance
          .collection('analytics').doc(nowDate)
          .get();
      print(analyticsSnap);
      if(analyticsSnap.data == null){
        final newDoc = FirebaseFirestore.instance
            .collection('analytics').doc(nowDate);
        final json  ={
          'date': DateTime.now(), // John Doe
          'likes': 0, // Stokes and Sons
          'login': 0,
          'posts':0,
          'signup':0,
          'reportedPosts':0,
          'comments':0
        };
        await newDoc.set(json);
        getData();
        setState(() {
          analyticsSnapData = analyticsSnap.data();
        });
        print("---------->");
        print(analyticsSnapData['posts']);
      }
    }
    catch (e){
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      analyticsSnapData = analyticsSnap.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: SafeArea(

      child: SingleChildScrollView(
      child: Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(child: Text("Admin Panel",style: kTitleTextStyle,),alignment: Alignment.center,decoration: BoxDecoration(
      color: Color(0xFF8D8E98),
      borderRadius: BorderRadius.circular(10.0),
      ),),
      SizedBox(height: 10,),
      TextButton(onPressed: (){
      getData();
      }, child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.refresh),
    Text("Refresh",style: kBodyTextStyle,),
    ],
    )),
    Text("Today's activity...",),
    Row(mainAxisAlignment: MainAxisAlignment.center,children: [tile("Posts\n",analyticsSnapData['posts']),
    tile("Likes\n",analyticsSnapData['likes']),],),
    Row(mainAxisAlignment: MainAxisAlignment.center,children: [tile("Logins\n",analyticsSnapData['login']),
    tile("New\n Sign-Ups",analyticsSnapData['signup']),],),
    Row(mainAxisAlignment: MainAxisAlignment.center,children: [tile("Reported Posts",analyticsSnapData['reportedPosts']),
    tile("Comments\n",analyticsSnapData['comments']),],)


    ],
    ),
    ),
    ),);
  }

  Widget tile(String label, dynamic Value){
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
