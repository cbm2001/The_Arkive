import 'package:cloud_firestore/cloud_firestore.dart';

var userData1 = {};

var analyticsData;
final currDoc =
    FirebaseFirestore.instance.collection("analytics").doc(currDate);
String currDate = DateTime.now().day.toString() +
    "-" +
    DateTime.now().month.toString() +
    "-" +
    DateTime.now().year.toString();
checkDoc() async {
  print(currDate);

  try {
    analyticsData = await FirebaseFirestore.instance
        .collection('analytics')
        .doc(currDate)
        .get();

    // get post lENGTH
    print(currDate);
    userData1 = analyticsData.data();

    if (userData1 == null) {
      final newDoc =
          FirebaseFirestore.instance.collection('analytics').doc(currDate);
      final json = {
        'date': DateTime.now(), // John Doe
        'likes': 0, // Stokes and Sons
        'login': 0,
        'posts': 0,
        'signup': 0,
        'reportedPosts': 0,
        'comments': 0
      };
      await newDoc.set(json);
    }
  } catch (e) {}
}

addLogin() async {
  int x = userData1['login'];
  if (x == null) {
    addLogin();
  } else {
    int y = x + 1;
    await currDoc.update({
      "login": y,
    });
  }
}

addPost() async {
  int x = userData1['posts'];
  if (x == null) {
    addPost();
    print("this is x:" + x.toString());
  } else {
    int y = x + 1;
    await currDoc.update({
      "posts": y,
    });
  }
}

addComment() async {
  int x = userData1['comments'];
  if (x == null) {
    addComment();
  } else {
    int y = x + 1;
    await currDoc.update({
      "comments": y,
    });
  }
}

addSignup() async {
  int x = userData1['signup'];
  if (x == null) {
    addSignup();
  } else {
    int y = x + 1;
    await currDoc.update({
      "signup": y,
    });
  }
}

addLike() async {
  int x = userData1['likes'];
  if (x == null) {
    addLike();
  } else {
    int y = x + 1;
    await currDoc.update({
      "likes": y,
    });
  }
}

addReportedPosts() async {
  int x = userData1['reportedPosts'];
  if (x == null) {
    addReportedPosts();
  } else {
    int y = x + 1;
    await currDoc.update({
      "reportedPosts": y,
    });
  }
}
