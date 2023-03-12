import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/ar_camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';
import '../screens/post_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/user_provider.dart';
import '../screens/explore_screen.dart';

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key key}) : super(key: key);

  @override
  _MyNavigationState createState() => _MyNavigationState();
}

class _MyNavigationState extends State<MyNavigationBar> {
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  int _selectedIndex = 0;
  List<Widget> pageList = [
    ExplorePage(),
    SearchPage(),
    PostPage(),
    ARPage(),
    ProfilePage(
      uid: FirebaseAuth.instance.currentUser.uid,
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.black),
              label: 'Search',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded, color: Colors.black),
            label: 'Posts',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye, color: Colors.black),
            label: 'View',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined, color: Colors.black),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
