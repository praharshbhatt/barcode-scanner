import 'package:flutter/material.dart';

//This Package contains the widgets for all the shapes used in the app

//Get the Rounded shape for cards
RoundedRectangleBorder roundedShape() {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  ));
}
