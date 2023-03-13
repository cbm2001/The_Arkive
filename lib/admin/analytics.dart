
import 'package:cloud_firestore/cloud_firestore.dart';

var userData = {};
var analyticsData;
final currDoc = FirebaseFirestore.instance
    .collection("analytics")
    .doc(currDate);
String currDate = DateTime.now().day.toString()+ "-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
checkDoc() async {
  print(currDate);

  try {

    analyticsData = await FirebaseFirestore.instance
        .collection('analytics').doc(currDate)
        .get();

    // get post lENGTH
    print(currDate);
    userData = analyticsData.data();

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

    }
  } catch (e) {

  }




}
addLogin() async{

  int x = userData['login'];
  int y = x + 1;
  await currDoc.update({
    "login": y,
  });
}
addPost() async{

  int x = userData['posts'];
  int y = x + 1;
  await currDoc.update({
    "posts": y,
  });
}
addComment() async{

  int x = userData['comments'];
  int y = x + 1;
  await currDoc.update({
    "comments": y,
  });
}
addSignup() async{

  int x = userData['signup'];
  int y = x + 1;
  await currDoc.update({
    "signup": y,
  });
}
addLike() async{

  int x = userData['likes'];
  int y = x + 1;
  await currDoc.update({
    "likes": y,
  });
}

addReportedPosts() async{

  int x = userData['reportedPosts'];
  int y = x + 1;
  await currDoc.update({
    "reportedPosts": y,
  });
}
