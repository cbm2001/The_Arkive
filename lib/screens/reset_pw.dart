import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'explore_screen.dart';
import '../widgets/reusable_widgets.dart';

class ResetPassword extends StatefulWidget {
  //const SignUpScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  Future get passwordReset async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text);
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Text(
                  'The reset password link is sent! Please check your email'),
            );
          }));
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }));
    }
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
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Please enter account\'s registered email id and an email will be sent with an link to reset your account \'s password.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: reusableTextField(
                    "Enter Email Id", 
                    Icons.email, 
                    false, _emailTextController),
                width: 350,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      fixedSize: Size(350, 50)),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailTextController.text);
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              content: Text(
                                  'The reset password link is sent! Please check your email'),
                            );
                          }));
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              content: Text(e.message.toString()),
                            );
                          }));
                    }
                  },
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      //fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      //backgroundColor: Colors.white,
                    ),
                  )),
              /*firebaseUIButton(context, "Reset Password", () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailTextController.text)
                    .then((value) => Navigator.of(context).pop());
              })*/
            ],
          ),
        ));
  }
}
