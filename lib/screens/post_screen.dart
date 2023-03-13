import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/map_screen.dart';
import 'package:first_app/screens/search_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:first_app/resources/locationMethods.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Uint8List _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  // double latitude;
  // double longitude;
  GeoPoint geoLoc;
  String category = '';

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

  Future<bool> postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file,
          uid,
          username,
          _locationController.text,
          category,
          profImage,
          // latitude,
          // longitude
          geoLoc);
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
    return true;
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

    return _file == null
        ? Column(
            children: [
              SizedBox(height: 300),
              Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.upload,
                  ),
                  iconSize: 45,
                  onPressed: () => _selectImage(context),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () => _selectImage(context),
                child: Text(
                  'Upload ScrapBook',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(139, 134, 134, 1), fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                  fixedSize: Size(150, 40),
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                ),
              ),
            ],
          )
        : Scaffold(
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
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ),
                TextButton(
                  onPressed: () => draftImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "Save as draft",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            // POST FORM
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(),
                  /*Row(
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
                      ]),*/
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: 687 / 651,
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file),
                        )),
                      ),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 40,
                    width: 350,
                    child: reusableTextField("Write a caption",
                        Icons.description, false, _descriptionController),
                    //maxLines: 8,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    child: Row(
                      children: [
                        Text(
                          "Select Category :   ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        DropdownButton<String>(
                          value: category,
                          items: [
                            '',
                            'travel',
                            'sports',
                            'food',
                            'art',
                            'lifestyle'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  /*SizedBox(
                    height: 40,
                    width: 350,
                    child: reusableTextField("Tag location(s)",
                        Icons.share_location, false, _locationController),
                    //maxLines: 8,
                  ),*/
                  ElevatedButton(
                      onPressed: () {
                        print("here");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapSearchPage(gpVal: (value) {
                              print("and here");
                              setState(() {
                                geoLoc = value;
                              });
                            }),
                          ),
                        );
                      },
                      child: Text("Search for location"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 50),
                        backgroundColor: Color.fromRGBO(255, 248, 185, 1),
                        foregroundColor: Color.fromRGBO(139, 134, 134, 1),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Center(child: Text("Or")),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        GeoPoint pos = await determinePosition();

                        setState(() {
                          isLoading = false;
                          String x = '123';

                          geoLoc = pos;
                          if (!isLoading) {
                            showSnackBar(context, "location received!");
                          }
                        });
                      },
                      child: Text("Get Current location"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 50),
                        backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                        foregroundColor: Color.fromRGBO(139, 134, 134, 1),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
  }

  Future<bool> draftImage(String uid, String username, String profImage) async {
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
          category,
          profImage,
          // latitude ,
          // longitude
          geoLoc);
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
    return true;
  }
}
