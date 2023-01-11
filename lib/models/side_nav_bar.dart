import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';

class NavBar extends StatefulWidget {
  //NavigationBar({Key key}) : super(key: key);
  final String uid;

  const NavBar({Key key, @required this.uid}) : super(key: key);
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavBar> with TickerProviderStateMixin {
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

    final upperTab = FirebaseAuth.instance.currentUser.uid == user.uid
        ? TabBar(
            //labelColor: Colors.yellow,
            /*indicatorWeight: 1.0,
      //unselectedLabelColor: Colors.blue,
      indicatorColor: Colors.black,*/
            tabs: [
                //if (FirebaseAuth.instance.currentUser.uid == user.uid)
                Tab(
                  icon: new Icon(
                    Icons.post_add,
                    color: Colors.black,
                  ),
                  child: Text('posts',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
                ),
                Tab(
                  icon: new Icon(
                    Icons.folder_copy_sharp,
                    color: Colors.black,
                  ),
                  child: Text('folders',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
                ),
                Tab(
                  icon: new Icon(
                    Icons.drive_file_rename_outline_sharp,
                    color: Colors.black,
                  ),
                  child: Text('drafts',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
                )
                //else(FirebaseAuth.instance.currentUser.uid == user.uid)
              ])
        : TabBar(
            //labelColor: Colors.yellow,
            /*indicatorWeight: 1.0,
      //unselectedLabelColor: Colors.blue,
      indicatorColor: Colors.black,*/
            tabs: [
                //if (FirebaseAuth.instance.currentUser.uid == user.uid)
                Tab(
                  icon: new Icon(
                    Icons.post_add,
                    color: Colors.black,
                  ),
                  child: Text('posts',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
                ),
                Tab(
                  icon: new Icon(
                    Icons.folder_copy_sharp,
                    color: Colors.black,
                  ),
                  child: Text('folders',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromRGBO(139, 134, 134, 1))),
                ),

                //else(FirebaseAuth.instance.currentUser.uid == user.uid)
              ]);

    return DefaultTabController(
      //length: FirebaseAuth.instance.currentUser.uid == user.uid ? 3 : 2,
      length: upperTab.tabs.length,
      child: Scaffold(
          extendBodyBehindAppBar: false,

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
          body: FirebaseAuth.instance.currentUser.uid == user.uid
              ? TabBarView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(228, 255, 211, 1),
                      alignment: Alignment.center,
                      child: const Text('Page 1'),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(192, 234, 240, 1),
                      alignment: Alignment.center,
                      child: const Text('Page 2'),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(255, 248, 185, 1),
                      alignment: Alignment.center,
                      child: const Text('Page 3'),
                    ),
                  ],
                )
              : TabBarView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(228, 255, 211, 1),
                      alignment: Alignment.center,
                      child: const Text('Page 1'),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(192, 234, 240, 1),
                      alignment: Alignment.center,
                      child: const Text('Page 2'),
                    ),
                  ],
                )),
    );
  }
}
