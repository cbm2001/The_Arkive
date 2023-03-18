import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
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
            itemBuilder: (ctx, index) => Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Card(
                        child: PostCard(snap: snapshot.data.docs[index].data()),
                        elevation: 10,
                      ),
                      Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 7,
                            child: TextButton(onPressed: (){
                              var xyz = FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(snapshot.data.docs[index].data()['postId']);
                              xyz.delete();
                              print("hello");
                            }, child: Text("Take Down"),
                            style: ButtonStyle(backgroundColor : MaterialStateProperty.all(Colors.red),foregroundColor: MaterialStateProperty.all(Colors.black)),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(flex: 7,
                            child: TextButton(onPressed: (){
                              print("hello1");
                              var x = FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(snapshot.data.docs[index].data()['postId']);
                              x.update({"flag": false});
                            }, child: Text("Un-Flag"),
                            style: ButtonStyle(backgroundColor : MaterialStateProperty.all(Colors.lightGreen),foregroundColor: MaterialStateProperty.all(Colors.black)),
                            ),

                          ),
                          Expanded(flex: 1, child: SizedBox())
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        },
      ),
    );

  }
}
