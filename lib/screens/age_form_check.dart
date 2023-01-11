import 'package:first_app/main.dart';
import 'package:first_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class AgeCheck extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(211, 211, 211, 1),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData.fallback(),
          /*title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          )*/
        ),
        body: Builder(
          builder: (context) => Center(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Please enter your age to check if you\'re above the minimum age in order to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                        SizedBox(height: 100),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter your age:",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                              width: 30.0,
                              style: BorderStyle.solid,
                              color: Colors.black87,
                            )),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required*';
                            } else if (int.tryParse(value) < 18) {
                              return 'Below the age requirement';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: (() {
                            if (!_formKey.currentState.validate()) {
                              return Scaffold.of(context).showBottomSheet<void>(
                                (BuildContext context) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 200,
                                    //color: Color.fromRGBO(192, 234, 240, 1),
                                    color: Colors.white,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'You cannot create an account since you\’re underaged! \n Don\’t worry, you can always create an account when you\’re older. ',
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 15),
                                          ElevatedButton(
                                            child: const Text('Close'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(350, 50),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            Scaffold.of(context).showBottomSheet<void>(
                              (BuildContext context) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  //color: Color.fromRGBO(192, 234, 240, 1),
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'You\'re all set and ready to go! \n All you have to do now is log in to use the application',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          child: const Text('Next'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInScreen()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            foregroundColor: Colors.white,
                                            minimumSize: Size(350, 50),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                          child: Text('Submit', style: TextStyle(fontSize: 15)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            minimumSize: Size(350, 50),
                          ),
                        )
                      ],
                    ))),
          ),
        ));
  }
}
