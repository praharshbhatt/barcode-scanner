import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mera_store/screens/homeScreen.dart';
import 'package:mera_store/widgets/buttons.dart';
import 'package:mera_store/widgets/dialogboxes.dart';
import '../../main.dart';

//==================This is the Login Screen for the app==================
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  //Animation
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    //For animation
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(curve);

    Timer(Duration(milliseconds: 500), () {
      _animController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    //Animation
    _animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/animations/amazon-go.gif",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
              ),
            ),

            //Body
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Title
                    Padding(
                        padding: const EdgeInsets.fromLTRB(35, 50, 5, 20),
                        child: FadeTransition(
                          child: SlideTransition(
                            position: _animOffset,
                            child: Text("Hello there!",
                                style: TextStyle(
                                    fontSize: size * 0.09,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                          opacity: _animController,
                        )),

                    //Description
                    Padding(
                        padding: const EdgeInsets.all(35),
                        child: FadeTransition(
                          child: SlideTransition(
                            position: _animOffset,
                            child: Text(
                                "Let us get started by signing into Mera Store with Google.\n\nOnce you are logged in, your prefrences will get saved, and you will be able to start shopping right away!",
                                style: TextStyle(
                                    fontSize: size * 0.04,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                                textAlign: TextAlign.left),
                          ),
                          opacity: _animController,
                        )),
                  ],
                ),

                //Get the login Button
                Padding(padding: const EdgeInsets.all(40), child: getLogInButton())
              ],
            ),
          ],
        )),
      ),
    );
  }

  //Get the login button
  getLogInButton() {
    return primaryRaisedButton(
      context: context,
      text: "Log In using Google",
      textColor: myAppTheme.backgroundColor == Colors.white ? Colors.white : Colors.black,
      onPressed: () {
        //LOGIN USING GOOGLE HERE
        showLoading(context);

        authService.googleSignIn().then((user) {
          if (user == null) {
            //Login failed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Failed to log in!"),
                  content: new Text(
                      "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            //Navigate to the HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      },
    );
  }
}
