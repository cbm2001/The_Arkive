import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/explore_screen.dart';
import 'package:flutter/foundation.dart';
//import 'package:first_app/screens/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/auth_methods.dart';
import '../widgets/reusable_widgets.dart';
//import '../screens/login_screen.dart';
import '../utils/utils.dart';
import 'age_form_check.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmpasswordTextController =
      TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _bioTextController = TextEditingController();
  bool _isLoading = false;
  Uint8List _image;

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    if (_passwordTextController.text == _confirmpasswordTextController.text) {
      // signup user using our authmethodds
      String res = await AuthMethods().signUpUser(
          email: _emailTextController.text,
          password: _passwordTextController.text,
          username: _userNameTextController.text,
          name: _nameTextController.text,
          bio: _bioTextController.text,
          file: _image);
      if (res == "success") {
        /*setState(() {
        _isLoading = true;
      });*/
        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AgeCheck()),
        );
      } else {
        /*setState(() {
        _isLoading = false;
      });*/
        // show the error
        showSnackBar(context, res);
      }
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Text('Password entered has been wrong'),
            );
          }));
    }
    setState(() {
      _isLoading = false;
    });
    // if string returned is sucess, user has been created
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar

    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData.fallback(),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 20),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 44,
                          backgroundImage: MemoryImage(_image),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 44,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 50,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField("Enter Name", Icons.person_outline,
                    false, _nameTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField(
                    "Enter Email Id", Icons.email, false, _emailTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField("Enter UserName", Icons.person_outline,
                    false, _userNameTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField(
                    "Enter your bio", Icons.notes, false, _bioTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField("Enter Password", Icons.lock_outlined,
                    true, _passwordTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: reusableTextField("Confirm Password",
                    Icons.lock_outlined, true, _confirmpasswordTextController),
                width: 350,
              ),
              SizedBox(
                height: 10,
              ),
              /*SizedBox(
                height: 50,
                child: reusableTextField("Confirm Password",
                    Icons.lock_outlined, true, _passwordTextController),
                width: 350,
              ),*/
              /*firebaseUIButton(context, "Sign Up", () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print("Account Creation under progress");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AgeCheck()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                  print("Account creation process is terminated");
                });
              }),*/

              /*GestureDetector(
                child: Text('Sign Up'),
                onTap: (() {}),
              ),*/
              ElevatedButton(
                onPressed: (() {
                  // if(_image==null){
                  //   showSnackBar(context, "Upload Profile Picture");
                  // }
                  // else {
                  signUpUser();
                  // }
                }),
                child: !_isLoading
                    ? const Text(
                        'Sign up',
                      )
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    fixedSize: Size(350, 50)),
              ),
              /*ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgeCheck()),
                  );
                },
                child: const Text('Next'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    fixedSize: Size.fromWidth(350)),
              ),*/
            ],
          ),
        )));
  }
}
