import 'package:first_app/services/auth/firebase_auth_service.dart';
import 'package:first_app/services/auth/firebase_options.dart';

import 'package:first_app/admin/admin_login.dart';
import 'package:first_app/admin/panel.dart';

import 'admin/dashboard.dart';
import 'resources/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
//import './screens/explore_screen.dart';
//import './models/nav_bar.dart';
import 'models/nav_bar.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await AuthService().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App',
          //home: MyHomePage(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return MyNavigationBar();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return MyHomePage();
            },
          ),
        ));
  }
}

/*class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter App'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              color: Colors.blue,
              child: Container(width: 100, child: Text('Chart')),
              elevation: 5,
            ),
            Card(child: Text('List of TX')),
          ],
        ));
  }
}*/
/*
Border.all(width: 2.0, color: const Color(0xFFFFFFFF))
*/
class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(192, 234, 240, 1),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Column(
              /*mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,*/
              children: <Widget>[
                Text(
                  'THE ARKIVE',
                  style: TextStyle(
                      color: Color.fromRGBO(254, 228, 255, 1),
                      fontSize: 50,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.04,
                      height: 9.0,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Color.fromRGBO(243, 96, 211, 1)),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Color.fromRGBO(243, 96, 211, 1)),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Color.fromRGBO(243, 96, 211, 1)),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Color.fromRGBO(243, 96, 211, 1)),
                      ]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  }),

                  /*child: GestureDetector(
                      child: Text('Login'),
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                      })),*/
                  child: Text('Login'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(255, 250, 202, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(3),
                    minimumSize: MaterialStateProperty.all(Size(300, 40)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  }),
                  child: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(255, 250, 202, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(3),
                    minimumSize: MaterialStateProperty.all(Size(300, 40)),
                    //shadowColor: Colors.greenAccent,
                    //minimumSize: Size(15, 40), //////// HERE
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => adminLogin()),
                    );
                  }),
                  child: Text('Admin'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(255, 250, 202, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(3),
                    //fixedSize: MaterialStateProperty.all(Size.fromWidth(200)),
                    minimumSize: MaterialStateProperty.all(Size(300, 40)),
                  ),
                ),
                /*Column(

                )*/
              ]),
        ));
  }
}

/*class Button extends StatelessWidget {
  //const Button({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
            shadowColor: Colors.greenAccent,
            elevation: 3,
            //minimumSize: Size(15, 40), //////// HERE
          ),
          onPressed: () {},
          child: Text('Hey bro'),
        )
      ],
    )));
  }
}*/

/*
decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Color(0xFFDFDFDF)),
        left: BorderSide(color: Color(0xFFDFDFDF)),
        right: BorderSide(color: Color(0xFF7F7F7F)),
        bottom: BorderSide(color: Color(0xFF7F7F7F)),
      ),
      color: Color(0xFFBFBFBF),
    ),
*/