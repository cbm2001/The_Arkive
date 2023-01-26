import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/post_screen.dart';
import 'package:first_app/resources/auth_methods.dart';
import 'package:first_app/screens/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/side_nav_bar.dart';
import '../models/nav_bar.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import '../main.dart';
import '../widgets/post_card.dart';
import '../widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import 'package:first_app/widgets/draft_card.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key key, @required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final TextEditingController _textController = TextEditingController();
var userData = {};

class _ProfilePageState extends State<ProfilePage> {
  //const SearchPage({Key key}) : super(key: key);

  var upperTab;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();

      // get post lENGTH

      userData = userSnap.data();
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    upperTab = //FirebaseAuth.instance.currentUser.uid == userData['uid']
        TabBar(tabs: [
      //if (FirebaseAuth.instance.currentUser.uid == user.uid)
      Tab(
        icon: new Icon(
          Icons.post_add,
          color: Colors.black,
        ),
        child: Text('posts',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
      ),
      Tab(
        icon: new Icon(
          Icons.folder_copy_sharp,
          color: Colors.black,
        ),
        child: Text('folders',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
      ),
      Tab(
        icon: new Icon(
          Icons.drive_file_rename_outline_sharp,
          color: Colors.black,
        ),
        child: Text('drafts',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
      )
    ]);
    /*: TabBar(tabs: [
            //if (FirebaseAuth.instance.currentUser.uid == user.uid)
            Tab(
              icon: new Icon(
                Icons.post_add,
                color: Colors.black,
              ),
              child: Text('posts',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
            ),
            Tab(
              icon: new Icon(
                Icons.folder_copy_sharp,
                color: Colors.black,
              ),
              child: Text('folders',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
            ),

            //else(FirebaseAuth.instance.currentUser.uid == user.uid)
          ]);*/
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new ProfilePage()));
              //width: double.infinity,
              //height: double.infinity,
              child: Column(
                children: [
                  Row(children: <Widget>[
                    //SizedBox(width: 150, height: 20),

                    Padding(
                      padding: EdgeInsets.only(left: 155, top: 40.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 40.0,
                      ),
                    ),

                    IconButton(
                      icon: new Icon(
                        Icons.menu,
                      ),
                      iconSize: 40,
                      padding: EdgeInsets.only(left: 110, bottom: 1.5),
                      alignment: Alignment.topLeft,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => menuBar(context)),
                        );
                      },
                    )
                  ]),
                  SizedBox(height: 5.0),
                  Center(
                    child: Text(
                      //'Barbie Slayer',
                      userData['name'],
                      //user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    //'@urgalbarbz \n Only slays and sandwiches',
                    '@${userData['username']}',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    //'@urgalbarbz \n Only slays and sandwiches',
                    userData['bio'],
                    style: TextStyle(
                        color: Color.fromRGBO(139, 134, 134, 1),
                        fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 500,
                    child: DefaultTabController(
                      length: upperTab.tabs.length,
                      child: Scaffold(
                          extendBodyBehindAppBar: true,

                          //backgroundColor: Colors.lightGreen,
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(80),
                            child: AppBar(
                              bottom: PreferredSize(
                                preferredSize: upperTab.preferredSize,
                                child: Material(
                                  color: Colors.white, //<-- SEE HERE
                                  child: upperTab,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              iconTheme: IconThemeData(color: Colors.white),
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              SizedBox(
                                  height: 400,
                                  width: 400,
                                  child: FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('posts')
                                        .where('uid',
                                            isEqualTo: userData['uid'])
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (snapshot.data as dynamic)
                                            .docs
                                            .length,
                                        itemBuilder: (ctx, index) => PostCard(
                                            snap: snapshot.data.docs[index]
                                                .data()),
                                        /*return Container(
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );*/
                                      );
                                    },
                                  )),
                              Container(
                                height: MediaQuery.of(context).size.height,
                                color: Color.fromRGBO(192, 234, 240, 1),
                                alignment: Alignment.center,
                                child: const Text('Page 2'),
                              ),
                              SizedBox(
                                  height: 400,
                                  width: 400,
                                  child: FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('drafts')
                                        .where('uid',
                                            isEqualTo: userData['uid'])
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (snapshot.data as dynamic)
                                            .docs
                                            .length,
                                        itemBuilder: (ctx, index) => DraftCard(
                                            snap: snapshot.data.docs[index]
                                                .data()),
                                        /*return Container(
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );*/
                                      );
                                    },
                                  )),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget menuBar(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData.fallback(),
            ),
            preferredSize: Size.fromHeight(90.0)),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 80, 20, 0),
          width: 390,
          //width: double.infinity,
          height: 600,
          //padding: EdgeInsets.only(left: 20),
          color: Color.fromRGBO(213, 245, 208, 1),
          child: Column(
            children: <Widget>[
              SizedBox(height: 150),
              ElevatedButton(
                onPressed: () async {
                  await AuthMethods().signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Text(
                  'Logout',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                  fixedSize: Size(300, 50),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => accountSettings(context)),
                  );
                },
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(254, 228, 255, 1),
                  fixedSize: Size(300, 50),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                ),
              ),
            ],
          ),
        ));
  }
}

Widget accountSettings(BuildContext context) {
  return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData.fallback(),
          ),
          preferredSize: Size.fromHeight(90.0)),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 80, 20, 0),
        width: 390,
        //width: double.infinity,
        height: 600,
        //padding: EdgeInsets.only(left: 20),
        color: Color.fromRGBO(192, 234, 240, 1),
        child: Column(
          children: <Widget>[
            SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => updateBio(context)),
                );
              },
              child: Text(
                'update bio',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(254, 228, 255, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text(
                'change profile picture',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(213, 245, 208, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => updateUsername(context)),
                );
              },
              child: Text(
                'change username',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 248, 185, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => updateEmail(context)),
                );
              },
              child: Text(
                'update email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(254, 218, 193, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => updatePassword(context)),
                );
              },
              child: Text(
                'change password',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(231, 232, 253, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text(
                'deactivate account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 203, 200, 1),
                fixedSize: Size(300, 50),
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
            ),
          ],
        ),
      ));
}

Widget updateBio(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField(
                "Write a bio", Icons.description, false, _textController),

            //maxLines: 8,
          ),
          ElevatedButton(
              onPressed: () {
                final x = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userData["uid"]);
                final y =
                    FirebaseFirestore.instance.collection("Users").doc(x.id);

                String ss = _textController.text;
                y.update({
                  "bio": "$ss",
                });
                _textController.clear();
                showSnackBar(
                  context,
                  'Bio Updated!',
                );
                Navigator.pop(context);
              },
              child: Text("Update bio")),
        ],
      ),
    ),
  );
}

Widget updateUsername(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Enter new username", Icons.description,
                false, _textController),

            //maxLines: 8,
          ),
          ElevatedButton(
              onPressed: () {
                final x = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userData["uid"]);

                final y =
                    FirebaseFirestore.instance.collection("Users").doc(x.id);

                String ss = _textController.text;
                y.update({
                  "username": "$ss",
                });
                _textController.clear();
                showSnackBar(
                  context,
                  'username Updated!',
                );
                Navigator.pop(context);
              },
              child: Text("Update username")),
        ],
      ),
    ),
  );
}

Widget updatePassword(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Enter new password", Icons.description,
                false, _textController),

            //maxLines: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                // CircularProgressIndicator;
                // await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
                // final x = FirebaseFirestore.instance.collection("Users").doc(userData["uid"]);
                //
                // final y = FirebaseFirestore.instance.collection("Users").doc(x.id);
                //
                // String ss = _textController.text;
                //
                //
                // await FirebaseAuth.instance.currentUser.updatePassword(ss);
                // _textController.clear();
                // showSnackBar(
                //   context,
                //   'password Updated!',
                // );
                //
                // Navigator.pop(context);
                // FirebaseAuth.instance.signOut();
                //
              },
              child: Text("Update password")),
        ],
      ),
    ),
  );
}

Widget updateEmail(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField(
                "Enter new email", Icons.description, false, _textController),

            //maxLines: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                final x = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userData["uid"]);

                final y =
                    FirebaseFirestore.instance.collection("Users").doc(x.id);

                String ss = _textController.text;
                y.update({
                  "email": "$ss",
                });

                await FirebaseAuth.instance.currentUser.updateEmail(ss);
                _textController.clear();
                showSnackBar(
                  context,
                  'email Updated!',
                );

                Navigator.pop(context);
              },
              child: Text("Update email")),
        ],
      ),
    ),
  );
}
