import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mera_store/main.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/themes/maintheme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;
    return MaterialApp(
      theme: getMainThemeWithBrightness(context, Brightness.dark),
      home: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: myAppTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.grey),
            elevation: 0,
            titleSpacing: 0.0,
            centerTitle: true,
            backgroundColor: myAppTheme.scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: myAppTheme.iconTheme.color, size: myAppTheme.iconTheme.size),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Title
                Text(
                  userProfile.containsKey("name") ? userProfile["name"] : "Profile",
                  style: myAppTheme.textTheme.body2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          //Body
          body: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: <Widget>[
                  //Profile Photo
                  userProfile.containsKey("photo url")
                      ? Center(
                          child: InkWell(
                              child: Container(
                                height: size * 0.18,
                                width: size * 0.18,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(userProfile["photo url"]),
                                  minRadius: 90,
                                  maxRadius: 180,
                                ),
                              ),
                              onTap: () => {
                                    //TODO: Change the Profile picture
                                  }),
                        )
                      : Center(
                          child: IconButton(
                              icon: Icon(Icons.account_circle, color: myAppTheme.iconTheme.color),
                              iconSize: size * 0.18,
                              onPressed: () => {
                                    //TODO: Change the Profile picture
                                  }),
                        ),

                  //Profile Name
                  Card(
                      color: myAppTheme.cardColor,
                      margin: myAppTheme.cardTheme.margin,
                      shape: myAppTheme.cardTheme.shape,
                      elevation: 6,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        //Login ID
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your name",
                            style: myAppTheme.textTheme.caption,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            userProfile.containsKey("name") ? userProfile["name"] : "Unknown User",
                            style: myAppTheme.textTheme.body2,
                          ),
                        ),
                      ])),

                  //Profile Email
                  Card(
                      color: myAppTheme.cardColor,
                      margin: myAppTheme.cardTheme.margin,
                      shape: myAppTheme.cardTheme.shape,
                      elevation: 6,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        //Login ID
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your Email",
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
                ],
              )),
        ),
      ),
    );
  }
}
