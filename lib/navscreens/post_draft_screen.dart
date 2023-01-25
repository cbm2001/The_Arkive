import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';
String latitude;
String longitude;
class PostDraftPage extends StatefulWidget {
  final String postURL;
  const PostDraftPage({Key key,
    // String postID,
    @required this.postURL,
    // String category,
    // String description,
    // String location,
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
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file,
          uid,
          username,
          _locationController.text,
          _categoryController.text,
          profImage,
          latitude,
          longitude
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
    return _file == null
        ? Center(
      child: IconButton(
        icon: const Icon(
          Icons.upload,
        ),
        onPressed: () => _selectImage(context),
      ),
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
            onPressed: () =>
                uploadDraftPost(
                  userProvider.getUser.uid,
                  userProvider.getUser.username,
                  userProvider.getUser.photoUrl,
                ),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          TextButton(
            onPressed: () =>
                draftImage(
                  userProvider.getUser.uid,
                  userProvider.getUser.username,
                  userProvider.getUser.photoUrl,
                ),
            child: const Text(
              "Save as draft",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
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
                      image: MemoryImage(_file),
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
          SizedBox(
            height: 40,
            width: 350,
            child: reusableTextField("Tag a category\s",
                Icons.category_sharp, false, _categoryController),
            //maxLines: 8,
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
        latitude,
        longitude,
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