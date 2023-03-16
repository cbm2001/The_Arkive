import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/admin/analytics.dart';
//import 'package:first_app/screens/age_form_check.dart';
import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../widgets/reusable_widgets.dart';
import '../utils/utils.dart';
import './signup_screen.dart';
import '../screens/explore_screen.dart';
import 'reset_pw.dart';
import '../models/nav_bar.dart';

class SignInScreen extends StatefulWidget {
  //const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (res == 'success') {
      checkDoc();
      addLogin();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyNavigationBar()));

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Color.fromRGBO(211, 211, 211, 1),

        backgroundColor: Colors.white,
        elevation: 0, iconTheme: IconThemeData.fallback(),
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
            Text(
              'Log In',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
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
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
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
