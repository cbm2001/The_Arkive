import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'constants.dart';

class generateReports extends StatefulWidget {
  const generateReports({Key key}) : super(key: key);

  @override
  State<generateReports> createState() => _generateReportsState();
}

class _generateReportsState extends State<generateReports> {
  var userData = {};
  bool isLoading = false;
  int defDays = 7;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("(Click to change range)",style: TextStyle(decoration: TextDecoration.none,fontSize: 13,color: Colors.grey),),),
                  SizedBox(),
                slider(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tile1("Posts\n", posts(defDays)),
                tile1("Likes\n", likes(defDays)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tile1("Logins\n", logins(defDays)),
                tile1("New\n Sign-Ups", signups(defDays)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tile1("Reported Posts", reported_posts(defDays)),
                tile1("Comments\n", comments(defDays)),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Text> numOfDays(){
    List<Text> xyz = [];
    for(int y=1 ; y<=30; y++){
      xyz.add(Text(y.toString()));
    }
    return xyz;
  }

  Widget slider() {
    return CupertinoButton.filled(
      // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Text("Past " + defDays.toString() + " days"),
        onPressed: () =>
            showCupertinoModalPopup(context: context, builder: (_) => SizedBox(
              width: 250,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: defDays,),
                children: numOfDays(),
                onSelectedItemChanged: (int newVal){
                  setState(() {
                    defDays = newVal+1;
                  });
                },
              ),
            )));
  }

  Widget logins(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['login']),
        );
      },
    );
  }

  Widget likes(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['likes']),
        );
      },
    );
  }

  Widget posts(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['posts']),
        );
      },
    );
  }

  Widget comments(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['comments']),
        );
      },
    );
  }

  Widget signups(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['signup']),
        );
      },
    );
  }

  Widget reported_posts(int num_days) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .where('date',
              isGreaterThan: DateTime.now().subtract(Duration(days: num_days)))
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (ctx, index) => tile(
              DateFormat('dd-MMM-yyy')
                  .format(snapshot.data.docs[index].data()['date'].toDate())
                  .toString(),
              snapshot.data.docs[index].data()['reportedPosts']),
        );
      },
    );
  }

  Widget tile(String label, dynamic Value) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: kLabelTextStyle,
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  Value.toString(),
                  style: kNumberTextStyle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: double.infinity,
            height: 120,
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget tile1(String label, Widget analytics) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: kBodyTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => analytics),
            );
          },
        ),
      ),
    );
  }
}
