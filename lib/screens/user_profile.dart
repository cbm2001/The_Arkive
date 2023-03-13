import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/resources/auth_methods.dart';
import 'package:first_app/screens/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/side_nav_bar.dart';
import '../models/nav_bar.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import '../main.dart';
import '../widgets/folder_card.dart';
import '../widgets/post_card.dart';
import '../utils/utils.dart';


class UserProfilePage extends StatefulWidget {
  final String uid;
  const UserProfilePage({Key key, @required this.uid}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  //const SearchPage({Key key}) : super(key: key);

  var userData = {};
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

  /*void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }*/

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    upperTab = TabBar(tabs: [
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
    ]);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            //extendBodyBehindAppBar: false,
            //extendBody: false,
            /*appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData.fallback(),
          ),
          preferredSize: Size.fromHeight(50.0)),*/

            backgroundColor: Colors.white,
            body: Container(
              //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new ProfilePage()));
              //width: double.infinity,
              //height: double.infinity,
              child: Column(
                children: [
                  Row(children: <Widget>[
                    //SizedBox(width: 150, height: 20),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.only(bottom: 1.5),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 110, top: 50.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 40.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: IconButton(
                        onPressed: (() {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text('Report User'),
                                          ),
                                          onTap: () {
                                            // remove the dialog box
                                            Navigator.of(context).pop();
                                          }),
                                      InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text('Block User'),
                                          ),
                                          onTap: () {}),
                                    ].toList())),
                          );
                        }),
                        icon: Icon(Icons.more_vert),
                      ),
                    ),
                  ]),
                  SizedBox(height: 5.0),
                  Text(
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
                    height: 20,
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
                                      );
                                    },
                                  )),
                              Container(
                                  child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('folders')
                                    .where('uid', isEqualTo: userData['uid'])
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
                                    itemCount:
                                        (snapshot.data as dynamic).docs.length,
                                    itemBuilder: (ctx, index) => FolderCard(
                                        snap: snapshot.data.docs[index].data()),
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
}
