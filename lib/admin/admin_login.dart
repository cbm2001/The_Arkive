import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/admin/panel.dart';
import 'package:first_app/services/crud/user_service.dart';
import 'package:flutter/material.dart';

import '../screens/reset_pw.dart';
import '../screens/signup_screen.dart';
import '../utils/utils.dart';
import '../widgets/reusable_widgets.dart';
import 'analytics.dart';

class adminLogin extends StatefulWidget {
  const adminLogin({Key key}) : super(key: key);

  @override
  State<adminLogin> createState() => _adminLoginState();
}

class _adminLoginState extends State<adminLogin> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await UserService().loginUser(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (res == 'success') {
      var x = await FirebaseFirestore.instance
          .collection("admin")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      if (x.data() != null) {
        checkDoc();
        addLogin();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => panel()));
      } else {
        showSnackBar(context, "You are not an admin");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => adminLogin()));
      }

      /*setState(() {
        _isLoading = false;
      });*/
    } else {
      /*setState(() {
        _isLoading = false;
      });*/
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Color.fromRGBO(211, 211, 211, 1),

        backgroundColor: Color(0xFF111328),
        elevation: 1, iconTheme: IconThemeData.fallback(),
        /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
      ),
      //backgroundColor: Color.fromRGBO(192, 234, 240, 1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            /*logoWidget("assets/images/logo1.png"),
                const SizedBox(
                  height: 30,
                ),*/
            SizedBox(
              height: 10,
            ),
            Text(
              'Admin Log In',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF8D8E98)),
            ),
            SizedBox(height: 50),
            SizedBox(
                height: 50,
                width: 350,
                child: reusableTextField("Enter Email ID", Icons.person_outline,
                    false, _emailTextController)),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 350,
              child: reusableTextField("Enter Password", Icons.lock_outline,
                  true, _passwordTextController),
            ),
            SizedBox(height: 10),
            /*const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),*/
            /*ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  fixedSize: Size.fromWidth(350)),
            ),*/
            forgetPassword(context),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (() => loginUser()),
              child: !_isLoading
                  ? const Text(
                      'Log in',
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.black,
                  fixedSize: Size(350, 50)),
            ),

            /*firebaseUIButton(context, "Sign In", () {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                  .then((value) {
                print('Successfully logged in');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyNavigationBar()));
              }).onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });
            }),*/
            SizedBox(
              height: 5,
            ),
            signUpOption(),
          ],
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //textDirection: TextDirection.ltr,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: const Text("Don't have account?",
              style: TextStyle(color: Colors.black54, fontSize: 16)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black87),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
