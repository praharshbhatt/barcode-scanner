import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/shapes.dart';

//This file contains the main theme settings

//Return the ThemeData with Brightness
ThemeData getMainThemeWithBrightness(BuildContext context, Brightness appBrightness) {
  double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
      ? MediaQuery.of(context).size.width
      : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;


  //Set StatusBar color, navigationBar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    statusBarIconBrightness: appBrightness == Brightness.light ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    systemNavigationBarIconBrightness: appBrightness == Brightness.light ? Brightness.dark : Brightness.light,
  ));





  return ThemeData(
    // Define the default brightness and colors.
    brightness: appBrightness,
    primaryColor:
        appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 5, 144, 98),
    accentColor:
        appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 8, 195, 164),

    highlightColor: appBrightness == Brightness.light ? Colors.pinkAccent : Colors.green,
    cursorColor: appBrightness == Brightness.light ? Colors.pinkAccent : Colors.green,
    focusColor: appBrightness == Brightness.light ? Colors.pinkAccent : Colors.green,
    indicatorColor: appBrightness == Brightness.light ? Colors.pinkAccent : Colors.green,
    buttonColor: appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 8, 195, 164),

    splashColor:
        appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 8, 195, 164),
    primaryColorDark:
        appBrightness == Brightness.light ? Color.fromARGB(255, 234, 76, 137) : Color.fromARGB(255, 34, 95, 77),




    iconTheme: IconThemeData(
        color: appBrightness == Brightness.light ? Colors.black : Colors.white70, opacity: 1.0, size: size * 0.06),

    // Define the default font family.
    fontFamily: "Poppins",

    backgroundColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    scaffoldBackgroundColor: appBrightness == Brightness.light ? Colors.white : Colors.black,
    canvasColor: appBrightness == Brightness.light ? Colors.white : Colors.black,

    //For Card
    cardColor: appBrightness == Brightness.light ? Color.fromARGB(255, 250, 250, 250) : Color.fromARGB(255, 30, 30, 30),
    cardTheme: CardTheme(
      color: appBrightness == Brightness.light ? Color.fromARGB(255, 250, 250, 250) : Color.fromARGB(255, 30, 30, 30),
      elevation: 6,
      margin: EdgeInsets.all(12),
      shape: roundedShape(),
    ),

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(
          fontSize: size * 0.085,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      title: TextStyle(
          fontSize: size * 0.08,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      caption: TextStyle(
          fontSize: size * 0.05,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      body1: TextStyle(
          fontSize: size * 0.04,
          fontFamily: "Poppins",
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      body2: TextStyle(
          fontSize: size * 0.038,
          fontFamily: "Poppins",
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      display1: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          fontSize: size * 0.04,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      display2: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.025,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      display3: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.035,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
      display4: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.045,
          color: appBrightness == Brightness.light ? Colors.black : Colors.white70),
    ),
  );
}
