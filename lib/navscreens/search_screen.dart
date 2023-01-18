import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/navscreens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:first_app/models/side_nav_bar.dart';
import '../screens/explore_screen.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../screens/user_profile.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //const SearchPage({Key key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    if (FirebaseAuth.instance.currentUser ==
                        (snapshot.data as dynamic).docs[index]['uid']) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              uid: (snapshot.data as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                                (snapshot.data as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                          title: Text(
                            (snapshot.data as dynamic).docs[index]['username'],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            uid: (snapshot.data as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                                (snapshot.data as dynamic).docs[index]
                                    ['photoUrl'])),
                        title: Text(
                          (snapshot.data as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : SizedBox(
              child: SearchNavBar(),
              height: 600,
            ),
      /*FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),*/
    );
  }
  /*Container(
          width: MediaQuery.of(context).size.width,
          //width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              /*SizedBox(height: 50),
              SizedBox(
                  height: 50,
                  width: 350,
                  child: reusableTextField("Search anything", Icons.search,
                      false, _searchController)),
              SizedBox(
                child: SearchNavBar(),
                height: 600,
              ),*/
            ],
          ),
        )*/

}

class SearchNavBar extends StatefulWidget {
  //NavigationBar({Key key}) : super(key: key);

  @override
  _SearchNavBarState createState() => _SearchNavBarState();
}

class _SearchNavBarState extends State<SearchNavBar> {
  final upperTab = TabBar(
    indicatorWeight: 3.0,
    indicatorColor: Colors.white,
    tabs: [
      Card(
        color: Color.fromRGBO(213, 245, 208, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SizedBox(
            child: Text(
              'friends',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
            ),
            height: 20,
            width: 90,
          ),
        ),
      ),
      Card(
        color: Color.fromRGBO(192, 234, 240, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SizedBox(
            child: Text(
              'location',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
            ),
            height: 20,
            width: 90,
          ),
        ),
      ),
      Card(
        color: Color.fromRGBO(255, 248, 185, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SizedBox(
            child: Text(
              'category',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(139, 134, 134, 1)),
            ),
            height: 20,
            width: 90,
          ),
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        //backgroundColor: Colors.lightGreen,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            bottom: upperTab,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              alignment: Alignment.center,
              child: const Text('Page 1'),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              alignment: Alignment.center,
              child: const Text('Page 2'),
            ),
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.white,
              child: Column(children: <Widget>[
                SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: Text('Choose a category:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    'sports',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      fixedSize: Size(343, 52),
                      backgroundColor: Color.fromRGBO(254, 228, 255, 1)),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    'food',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      fixedSize: Size(343, 52),
                      backgroundColor: Color.fromRGBO(255, 248, 185, 1)),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    'art',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      fixedSize: Size(343, 52),
                      backgroundColor: Color.fromRGBO(228, 255, 211, 1)),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    'travel',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      fixedSize: Size(343, 52),
                      backgroundColor: Color.fromRGBO(192, 234, 240, 1)),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    'lifestyle',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      fixedSize: Size(343, 52),
                      backgroundColor: Color.fromRGBO(237, 213, 249, 1)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
