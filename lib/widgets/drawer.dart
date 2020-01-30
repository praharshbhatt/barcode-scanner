import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/screens/account/signin.dart';
import 'package:mera_store/screens/profile.dart';
import 'package:mera_store/screens/settings.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/widgets/dialogboxes.dart';
import 'package:mera_store/widgets/shapes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

//NavDrawer
getDrawer(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
      ? MediaQuery.of(context).size.width
      : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Drawer(
      child: Container(
        color: myAppTheme.scaffoldBackgroundColor,
        child: ListView(
          children: <Widget>[
            //Header
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close, color: myAppTheme.iconTheme.color),
                  onPressed: () {
                    //Close the Menu
                    Navigator.pop(scaffoldKey.currentState.context);
                  },
                ),

                //Menu Text
                Text(
                  "Menu",
                  style: myAppTheme.textTheme.body1,
                  textAlign: TextAlign.center,
                ),

                //Profile
                userProfile.containsKey("photo url")
                    ? InkWell(
                        child: Container(
                          height: size * 0.06,
                          width: size * 0.06,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userProfile["photo url"]),
                            minRadius: 90,
                            maxRadius: 180,
                          ),
                        ),
                        onTap: () => _checkLoggedInUser(context))
                    : Center(
                        child: IconButton(
                            icon: Icon(Icons.account_circle),
                            iconSize: size * 0.06,
                            onPressed: () => _checkLoggedInUser(context)),
                      ),
              ]),
            ),

            //User Info
            Card(
                color: myAppTheme.cardColor,
                margin: EdgeInsets.all(12),
                shape: roundedShape(),
                elevation: 6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  //Login ID
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userProfile.containsKey("name") ? userProfile["name"] : "Unknown User",
                      style: myAppTheme.textTheme.caption,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      userProfile.containsKey("email") ? userProfile["email"] : "Unknown Email",
                      style: myAppTheme.textTheme.body2,
                    ),
                  ),
                ])),

            //Settings
            blIsSignedIn
                ? Card(
                    color: myAppTheme.cardColor,
                    margin: EdgeInsets.all(12),
                    shape: roundedShape(),
                    elevation: 6,
                    child: InkWell(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        //Login ID
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Settings",
                            style: myAppTheme.textTheme.caption,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Manage the settings and your prefrences from here",
                            style: myAppTheme.textTheme.body2,
                          ),
                        ),
                      ]),
                      onTap: () {
                        if (blIsSignedIn) {
                          //Open Settings screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsScreen()),
                          );
                        } else {
                          showSnackBar(scaffoldKey: scaffoldKey, text: "Please Log in first");
                        }
                      },
                    ),
                  )
                : Container(),

            //Log Out
            Card(
                color: myAppTheme.cardColor,
                margin: EdgeInsets.all(12),
                shape: roundedShape(),
                elevation: 6,
                child: blIsSignedIn
                    ? InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Sign Out",
                            style: myAppTheme.textTheme.caption,
                          ),
                        ),
                        onTap: () {
                          //Logout
                          showLogoutAlertDialog(context);
                        },
                      )
                    : InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Sign out",
                            style: myAppTheme.textTheme.caption,
                          ),
                        ),
                        onTap: () {
                          //Redirect to SignIn screen
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
                        },
                      )),

            //Made by
            Card(
              color: myAppTheme.cardColor,
              margin: EdgeInsets.all(12),
              shape: roundedShape(),
              elevation: 6,
              child: InkWell(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Made by Chetan Rakhasiya",
                      style: myAppTheme.textTheme.body2,
                    ),
                  ),
                ]),
                onTap: () async {
                  //Add Github link of the project
                  if (await canLaunch("https://multiverseapp.com/")) {
                    await launch("https://multiverseapp.com/");
                  } else {
                    throw "Could not launch";
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//Logout confirmation dialog
showLogoutAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {
      //Logout
      AuthService().signOut();

      //Redirect to SignIn screen
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Log out?"),
    content: Text("This will Log Out your account. Do you really wish to continue?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_checkLoggedInUser(BuildContext context) {
  //For mobile
  if (blIsSignedIn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  } else {
    //Redirect to SignIn screen
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
  }
}
