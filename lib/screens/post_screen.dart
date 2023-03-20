import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/map_screen.dart';
import 'package:first_app/screens/search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:screenshot/screenshot.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:first_app/resources/locationMethods.dart';
import 'package:first_app/services/location/location_service.dart';
import '../models/text_info.dart';
import '../widgets/image_text.dart';
import 'package:zoom_widget/zoom_widget.dart';
import '../widgets/overlayedWidget.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  Uint8List _file;
  Uint8List _scndFile;
  Image _scndImg;
  bool isLoading = false;
  String ment = "";
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  // double latitude;
  // double longitude;
  GeoPoint geoLoc;
  String category = '';
  // controller used to add text to photo
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  int currentIndex = 0;
  List<TextInfo> texts = [];
  List<Widget> _addedWidgets = [];
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Matrix4> notifierr = ValueNotifier(Matrix4.identity());
  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List image) {
      _file = image;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Scapboard Edit Saved')));
    }).catchError((err) => print(err));
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Text Selected For Styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  alignCentre() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Text Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
        text: textEditingController.text,
        left: 0,
        top: 0,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontSize: 20,
        textAlign: TextAlign.left,
      ));

      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text("Add New Text")),
        content: TextField(
          controller: textEditingController,
          maxLines: 2,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here...',
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Return',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(139, 134, 134, 1), fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                    fixedSize: Size(100, 35),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                  ),
                );
              }),
              SizedBox(width: 30),
              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () => addNewText(context),
                  child: Text(
                    'Add Text',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(139, 134, 134, 1), fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                    fixedSize: Size(100, 35),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  addDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Center(
                child: Text("Add Image"),
              ),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(width: 30),

                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          Uint8List file = await pickImage(ImageSource.gallery);

                          setState(() {
                            _scndFile = file;

                            //_scndImg = Image.memory(_scndFile);

                            _addedWidgets.add(
                              OverlayedWidget(
                                child: Image.memory(_scndFile),
                              ),
                            );
                          });
                        },
                        child: Text(
                          'Pick Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(139, 134, 134, 1),
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.70,
                              MediaQuery.of(context).size.height * 0.04),
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                        ),
                      );
                    }),

                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Return',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(139, 134, 134, 1),
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(192, 234, 240, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.70,
                              MediaQuery.of(context).size.height * 0.04),
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ));
  }

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
    saveToGallery(context);

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 2500));

    // start the loading

    try {
      // upload to storage and db

      String res = await FireStoreMethods().uploadPost(
          // _descriptionController.text + "Tags: " + ment,
          createCaption(),
          _file,
          uid,
          username,
          _locationController.text,
          category,
          profImage,
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

  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where(
          'username',
        )
        .get();

    var docs = querySnapshot.docs;

    for (var doc in docs) {
      data.add({'display': doc.data()['username']});
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  String captionNew;
  createCaption() {
    if (ment == "") {
      captionNew = _descriptionController.text;
    } else {
      captionNew = _descriptionController.text + " Tags: " + ment;
    }
    return captionNew;
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
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.amber,
                onPressed: clearImage,
              ),
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
                    "Draft",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ),
                SizedBox(
                  width: 15,
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
                  Screenshot(
                    controller: screenshotController,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Stack(
                        children: [
                          Container(
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
                          for (int i = 0; i < texts.length; i++)
                            Positioned(
                              left: texts[i].left,
                              top: texts[i].top,
                              child: GestureDetector(
                                onTap: () => setCurrentIndex(context, i),
                                child: Draggable(
                                  feedback: ImageText(textInfo: texts[i]),
                                  child: ImageText(textInfo: texts[i]),
                                  onDragEnd: (drag) {
                                    final renderBox =
                                        context.findRenderObject() as RenderBox;

                                    Offset off =
                                        renderBox.globalToLocal(drag.offset);

                                    setState(() {
                                      texts[i].top = off.dy - 120;

                                      texts[i].left = off.dx - 20;
                                    });
                                  },
                                ),
                              ),
                            ),
                          creatorText.text.isNotEmpty
                              ? Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Text(
                                    creatorText.text,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        )),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          for (int z = 0; z < _addedWidgets.length; z++)
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.395,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: _addedWidgets[z],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 90,
                                ),
                                Text(
                                  'Edit Scrapboard',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                TextButton(
                                  onPressed: () => saveToGallery(context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    "Save Edits",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 148, 79, 74),
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () => addDialog(context),
                                  child: Text(
                                    "Add Image",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.40,
                                        MediaQuery.of(context).size.height *
                                            0.04),
                                    backgroundColor:
                                        Color.fromRGBO(192, 234, 240, 1),
                                    foregroundColor:
                                        Color.fromRGBO(139, 134, 134, 1),
                                  )),
                              SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                  onPressed: () => addNewDialog(context),
                                  child: Text("Add Text"),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.40,
                                        MediaQuery.of(context).size.height *
                                            0.04),
                                    backgroundColor:
                                        Color.fromRGBO(192, 234, 240, 1),
                                    foregroundColor:
                                        Color.fromRGBO(139, 134, 134, 1),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      removeText(context);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Delete Text',
                                ),
                                IconButton(
                                  onPressed: () => increaseFontSize(),
                                  icon: const Icon(
                                    Icons.add,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Increase font Size',
                                ),
                                IconButton(
                                  onPressed: () => decreaseFontSize(),
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Decrease Font Size',
                                ),
                                IconButton(
                                  onPressed: () => boldText(),
                                  icon: const Icon(
                                    Icons.format_bold,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Bold',
                                ),
                                IconButton(
                                  onPressed: () => italicText(),
                                  icon: const Icon(
                                    Icons.format_italic,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Italic',
                                ),
                                Tooltip(
                                    message: 'Red',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.red,
                                      ),
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.red,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'White',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.white,
                                      ),
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Black',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.black,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 30,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Blue',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.blue,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 30,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Yellow',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.yellow,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.yellow,
                                        radius: 30,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Green',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.green,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 30,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Orange',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.orange,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.orange,
                                        radius: 30,
                                      ),
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Tooltip(
                                    message: 'Pink',
                                    child: GestureDetector(
                                      onTap: () => changeTextColor(
                                        Colors.pink,
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.pink,
                                        radius: 30,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                      color: Colors.grey.shade300,
                    ),
                    height: 40,
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "Tag Location",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    print("here");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MapSearchPage(gpVal: (value) {
                                          print("and here");

                                          setState(() {
                                            geoLoc = value;
                                          });
                                        }),
                                      ),
                                    );
                                  },
                                  child: Text("Search Location"),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.40,
                                        MediaQuery.of(context).size.height *
                                            0.04),
                                    backgroundColor:
                                        Color.fromRGBO(192, 234, 240, 1),
                                    foregroundColor:
                                        Color.fromRGBO(139, 134, 134, 1),
                                  )),
                              SizedBox(
                                width: 12,
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
                                        showSnackBar(
                                            context, "location received!");
                                      }
                                    });
                                  },
                                  child: Text("Current location"),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.40,
                                        MediaQuery.of(context).size.height *
                                            0.04),
                                    backgroundColor:
                                        Color.fromRGBO(192, 234, 240, 1),
                                    foregroundColor:
                                        Color.fromRGBO(139, 134, 134, 1),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Portal(
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 96,
                          width: 350,
                          child: reusableTextField("Write a caption",
                              Icons.description, false, _descriptionController),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 22,
                            ),
                            // ment == "" ? Container() : Text(ment),
                            SizedBox(
                              width: 275,
                              child: FlutterMentions(
                                key: key,
                                decoration: InputDecoration(
                                  hintText: "Tag someone",
                                ),
                                mentions: [
                                  Mention(
                                    trigger: "@",
                                    data: data,
                                    style: const TextStyle(
                                      color: Colors.pink,
                                    ),
                                    suggestionBuilder: (data) {
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(57, 0, 58, 0),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Color.fromARGB(
                                                  255, 237, 237, 237),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                          data['display'])),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    ment = key.currentState.controller.text;
                                    print(ment);
                                  });
                                  if (!isLoading) {
                                    showSnackBar(context, "User tagged!");
                                  }
                                },
                                child: Text("Tag"),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.15,
                                      MediaQuery.of(context).size.height *
                                          0.04),
                                  backgroundColor:
                                      Color.fromRGBO(192, 234, 240, 1),
                                  foregroundColor:
                                      Color.fromRGBO(139, 134, 134, 1),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
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

    try {
      String res = await FireStoreMethods().uploadDraft(
          _descriptionController.text,
          _file,
          uid,
          username,
          _locationController.text,
          category,
          profImage,
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
