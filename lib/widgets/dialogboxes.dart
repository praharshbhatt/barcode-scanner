import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

//Show Toast Message
void showSnackBar({@required scaffoldKey, String text, String buttonText, VoidCallback onPressed}) {
  try {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: myAppTheme.backgroundColor,
        content: Text(text, style: myAppTheme.textTheme.body2),
        action: SnackBarAction(label: buttonText, onPressed: onPressed),
      ),
    );
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}

// Return Alert Dialog Box
void showAlertDialog(BuildContext context, String title, String body) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: myAppTheme.backgroundColor,
        title: new Text(title, style: myAppTheme.textTheme.caption),
        content: new Text(body, style: myAppTheme.textTheme.body2),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close", style: myAppTheme.textTheme.body2),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//Show loading pop up
showLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: myAppTheme.backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        )),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(myAppTheme.accentColor)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: new Text("Loading, please wait...", style: myAppTheme.textTheme.body2),
              ),
            ],
          ),
        ),
      );
    },
  );
}
