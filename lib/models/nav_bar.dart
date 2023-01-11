import 'package:first_app/models/side_nav_bar.dart';
import 'package:flutter/material.dart';
import '../navscreens/search_screen.dart';
import '../navscreens/post_screen.dart';
import '../navscreens/map_screen.dart';
import '../navscreens/profile_screen.dart';
import '../screens/explore_screen.dart';

class MyNavBar extends StatefulWidget {
  //MyHomePage({Key key, this.title}) : super(key: key);
  //final String title;
  //MyNavBar({this.title});

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  //final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  int currentPageIndex = 0;
  ValueNotifier<bool> refreshPage = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: refreshPage,
      builder: (context, value, child) {
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
          },
          child: Scaffold(
            extendBodyBehindAppBar: false,
            backgroundColor: Colors.white,
            /*backgroundColor: _currentTabIndex == 0
                ? Colors.white
                : _currentTabIndex == 1
                    ? Colors.green
                    : Colors.green,*/
            /*appBar: AppBar(
              //backgroundColor: Color.fromRGBO(211, 211, 211, 1),

              backgroundColor: Colors.white,
              elevation: 0,
              //iconTheme: IconThemeData.fallback(),
              /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
            ),*/
            body: SingleChildScrollView(
              child: _currentTabIndex == 0
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0, right: 250),
                          child: Center(
                            child: Container(
                              width: 200.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: (const Text(
                                'Hello',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 300.0, top: 1.0),
                          child: IconButton(
                            icon: new Icon(Icons.account_circle, size: 30.0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notifications(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 300.0, top: 5.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              size: 25.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notifications(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Center(
                            child: Container(
                              width: 390,
                              height: 450,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _currentTabIndex == 1
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          //width: double.infinity,
                          height: MediaQuery.of(context).size.height,

                          child: Column(
                            children: <Widget>[
                              //SizedBox(height: 20),
                              Text(
                                'Search',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      : _currentTabIndex == 2
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              //width: double.infinity,
                              height: MediaQuery.of(context).size.height,

                              child: Column(
                                children: <Widget>[
                                  //SizedBox(height: 20),
                                  Text(
                                    'Create a  Post',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            )
                          : _currentTabIndex == 3
                              ? Column(
                                  children: [MapPage()],
                                )
                              /*Container(
                                  width: MediaQuery.of(context).size.width,
                                  //width: double.infinity,
                                  height: MediaQuery.of(context).size.height,

                                  child: Column(
                                    children: <Widget>[
                                      //SizedBox(height: 20),
                                      Text(
                                        'Map Feature',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                )*/
                              : Container(
                                  //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new ProfilePage()));
                                  //width: double.infinity,
                                  //height: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(children: <Widget>[
                                        //SizedBox(width: 150, height: 20),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 160, top: 50.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                                            radius: 40.0,
                                          ),
                                        ),

                                        IconButton(
                                          icon: new Icon(
                                            Icons.menu,
                                          ),
                                          iconSize: 40,
                                          padding: EdgeInsets.only(
                                              left: 110, bottom: 1.5),
                                          alignment: Alignment.topLeft,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage()),
                                            );
                                          },
                                        )
                                      ]),
                                      SizedBox(height: 5.0),
                                      Text(
                                        'Barbie Slayer',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        '@urgalbarbz \n Only slays and sandwiches',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                139, 134, 134, 1),
                                            fontSize: 14.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        color: Colors.lightGreen,
                                        child: Row(children: <Widget>[
                                          //SizedBox(width: 150, height: 20),
                                          ElevatedButton(
                                              onPressed: (() => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage()),
                                                  )),
                                              child: Text('posts')),
                                          ElevatedButton(
                                              onPressed: (() => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage()),
                                                  )),
                                              child: Text('folders')),
                                          ElevatedButton(
                                              onPressed: (() => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage()),
                                                  )),
                                              child: Text('drafts')),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
            ),
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      //type: BottomNavigationBarType.fixed,
      items: [
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
          icon: Icon(Icons.location_on_outlined, color: Colors.black),
          label: 'Map',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin_outlined, color: Colors.black),
          label: 'Profile',
          backgroundColor: Colors.white,
        ),
      ],

      //type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.black,
      iconSize: 30,
      onTap: _onTap,
      currentIndex: _currentTabIndex,
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        //Notifications();
        /*Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => ExplorePage()));*/
        break;
      case 1:
        Notifications();
        //  _navigatorKey.currentState.pushReplacementNamed("Page 2");
        //Navigator.of(context).pushReplacement(
        //  new MaterialPageRoute(builder: (context) => new SearchPage()));
        break;
      case 2:
        Notifications();
        // _navigatorKey.currentState.pushReplacementNamed("Profile");
        //Navigator.of(context).pushReplacement(
        //new MaterialPageRoute(builder: (context) => new ProfilePage()));
        break;
    }

    _currentTabIndex = tabIndex;
    refreshPage.value = !refreshPage.value;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Page 1":
        return MaterialPageRoute(builder: (context) => Notifications()
            // Container(
            //     color: Colors.green, child: Center(child: Text("Page 1")))
            );
      case "Page 2":
        return MaterialPageRoute(builder: (context) => Notifications()
            //  Container(
            //     color: Colors.green, child: Center(child: Text("Page 2")))
            );
      default:
        return MaterialPageRoute(builder: (context) => Notifications()
            // Container(
            //     color: Colors.green, child: Center(child: Text("Profile")))
            );
    }
  }
}

class Notifications extends StatefulWidget {
  Notifications({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NavitionState createState() => _NavitionState();
}

class _NavitionState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Notification",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Text("Notification Body"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
