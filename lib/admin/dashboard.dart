import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_app/admin/constants.dart';
import 'package:intl/intl.dart';

import '../screens/profile_screen.dart';
import '../utils/utils.dart';
class dashboard extends StatefulWidget {
  const dashboard({Key key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  var userSnap;
  var userData = {};
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
    String currDate = DateTime.now().day.toString()+ "-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
    print(currDate);
    try {

      userSnap = await FirebaseFirestore.instance
          .collection('analytics').doc(currDate)
          .get();

      // get post lENGTH
      print(currDate);
      userData = userSnap.data();
      setState(() {userData = userSnap.data();});
      if(userData==null)  {
        final newDoc = FirebaseFirestore.instance
            .collection('analytics').doc(currDate);
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
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }

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
                Row(children: [tile("Posts\n",userData['posts']),
                  tile("Likes\n",userData['likes']),],),
                Row(children: [tile("Logins\n",userData['login']),
                  tile("New\n Sign-Ups",userData['signup']),],),
                Row(children: [tile("Reported Posts",userData['reportedPosts']),
                  tile("Comments\n",userData['comments']),],)


              ],
            ),
          ),
        ));
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
            // print(DateFormat.yMMMd()
            //     .format(DateTime.now().subtract(Duration(days:30))));


            // getData();
            // print(userData['date']);

            // print(DateFormat.yMMMd()
            //     .format(userData['date'].toDate()));
            // print(userData['likes']);
          },
        ),
      ),
    );
  }
}
