import 'package:flutter/material.dart';

//This Package contains the widgets for all the decoration used in the app

//Get the Gradient Decoration
BoxDecoration gradientDecoration() {
  return BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1],
    colors: [
      Colors.orangeAccent,
      Colors.white,
    ],
  ));
}
