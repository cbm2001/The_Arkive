import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/post_card.dart';

class reportedPosts extends StatefulWidget {
  const reportedPosts({Key key}) : super(key: key);

  @override
  State<reportedPosts> createState() => _reportedPostsState();
}

class _reportedPostsState extends State<reportedPosts> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('flag',isEqualTo: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) => Card(
              child: PostCard(snap: snapshot.data.docs[index].data()),
              elevation: 10,
            ),
          );
        },
      ),
    );

  }
}
