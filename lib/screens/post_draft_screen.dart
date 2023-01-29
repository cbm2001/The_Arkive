import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/search_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../resources/locationMethods.dart';
import '../widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';

double latitude;
double longitude;
GeoPoint geoLoc;
String Category='travel';
class PostDraftPage extends StatefulWidget {
  final String postURL;
  final String category;
  final String description;
  final String location;
  final GeoPoint geoLoc;
  const PostDraftPage({Key key,
    // String postID,
    @required this.postURL,
    @required this.category,
    @required this.description,
    // String category,
    // String description,
    // String location,
    @required this.location,
    @required this.geoLoc,
  }) : super(key: key);

  @override
  _PostDraftPageState createState() => _PostDraftPageState();
}

class _PostDraftPageState extends State<PostDraftPage> {
  Uint8List _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();



  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void uploadDraftPost(String uid,
      String username,
      String profImage,
      // String postID,
      // String postURL,
      // String category,
      // String description,
      // String location,
      ) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadDraftPost(
          (_descriptionController.text == '')? widget.description:_descriptionController.text ,
          widget.postURL,
          uid,
          username,
          (_locationController.text== '')? widget.location:_locationController.text,
          (_categoryController.text == '')? widget.category:_categoryController.text ,
          profImage,
          // latitude ,
          // longitude
          (geoLoc == null)? widget.geoLoc:geoLoc
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    _descriptionController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text(
          'Post to',
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              uploadDraftPost(
                userProvider.getUser.uid,
                userProvider.getUser.username,
                userProvider.getUser.photoUrl,
              );
              Navigator.pop(context);
            },
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          // TextButton(
          //   onPressed: () =>
          //       draftImage(
          //         userProvider.getUser.uid,
          //         userProvider.getUser.username,
          //         userProvider.getUser.photoUrl,
          //       ),
          //   child: const Text(
          //     "Save as draft",
          //     style: TextStyle(
          //         color: Colors.blueAccent,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16.0),
          //   ),
          // ),
        ],
      ),
      // POST FORM
      body: Column(
        children: <Widget>[
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        // 'https://i.stack.imgur.com/l60Hf.png'
                          userProvider.getUser.photoUrl),
                      radius: 30,
                    ),
                    height: 80),
              ]),
          SizedBox(
            height: 85.0,
            width: 85.0,
            child: AspectRatio(
              aspectRatio: 487 / 451,
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                      image: NetworkImage(widget.postURL),
                    )),
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Write a caption", Icons.description,
                false, _descriptionController),
            //maxLines: 8,
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Tag location(s)",
                Icons.share_location, false, _locationController),
            //maxLines: 8,
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: ()  {
                print("here");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapSearchPage(gpVal: (value){
                      print("and here");
                      setState(() {
                        geoLoc = value;
                      });
                      showSnackBar(context, "location tagged!");
                    }) ,
                  ),
                );
              }

              ,
              child: Text("Search for location")),
          SizedBox(
            height: 5,
          ),
          Center(child: Text("Or")),

          ElevatedButton(onPressed: () async {
            setState((){
              isLoading=true;
            });


            GeoPoint pos =  await determinePosition();

            setState(() {
              isLoading=false;
              geoLoc = pos;
              if(!isLoading){
                showSnackBar(context, "location received!");
              }
            }


            );
          }, child: Text("Get location")),

          SizedBox(
            height: 5,
          ),

          Container(
            height: 40,
            width: 350,

            child: Row(
              children: [
                Text("Select Category:   "),
                DropdownButton<String>(value: Category ,items: ['travel','sports','food','art','lifestyle'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(), onChanged: (String newValue) {setState(() {
                  Category = newValue;

                });},),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void draftImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadDraft(
        _descriptionController.text,
        _file,
        uid,
        username,
        _locationController.text,
        _categoryController.text,
        profImage,
        // latitude ,
        // longitude ,
        geoLoc
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'drafted!',
        );
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
}
