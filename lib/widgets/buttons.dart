import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

//This Package contains the widgets for all the buttons used in the app

//This Returns the Primary Raised button with Icon
RaisedButton primaryRaisedIconButton(
    {@required BuildContext context,
    @required String text,
    @required Icon icon,
    double textSize,
    Color color,
    Color highlightColor,
    Color splashColor,
    Color textColor,
    VoidCallback onPressed}) {
  return RaisedButton.icon(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      )),
      color: color == null ? Color.fromARGB(255, 8, 195, 164) : color,
      disabledColor: Colors.blueGrey,
      highlightColor: highlightColor == null ? Color.fromARGB(255, 6, 218, 175) : highlightColor,
      splashColor: splashColor == null ? myAppTheme.accentColor : splashColor,
      icon: icon,
      label: Text(text, style: getTextStyle(context, textSize, textColor)),
      onPressed: () => onPressed());
}

//This Returns the Primary Raised button
RaisedButton primaryRaisedButton(
    {@required BuildContext context,
    @required String text,
    double textSize,
    Color color,
    Color highlightColor,
    Color splashColor,
    Color textColor,
    VoidCallback onPressed}) {
  return RaisedButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
      )),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      color: color == null ? myAppTheme.buttonColor : color,
      disabledColor: Colors.blueGrey,
      highlightColor: highlightColor == null ? Color.fromARGB(255, 6, 218, 175) : highlightColor,
      splashColor: splashColor == null ? Colors.white : splashColor,
      child: Text(text, style: getTextStyle(context, textSize, textColor)),
      onPressed: () => onPressed());
}

//Get the TextStyle from the given params
TextStyle getTextStyle(_context, _textSize, _textColor) {
  TextStyle _textStyle;

  //Defining size
  if (_textSize == null) _textSize =  myAppTheme.textTheme.body1.fontSize;
  //Defining textColor
  if (_textColor == null) {
    _textStyle = myAppTheme.textTheme.body1;
  } else {
    _textStyle = TextStyle(
      fontSize: _textSize,
      fontFamily: 'Poppins',
      color: _textColor,
    );
  }

  return _textStyle;
}
