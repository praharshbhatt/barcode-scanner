import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/main.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/widgets/appbar.dart';
import 'package:mera_store/widgets/dialogboxes.dart';
import 'package:mera_store/widgets/shapes.dart';

import '../themes/maintheme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myAppTheme.scaffoldBackgroundColor,
        appBar:
            getAppBar(scaffoldKey: _scaffoldKey, context: context, strAppBarTitle: "Settings", showBackButton: true),
        //Body
        body: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                //Theme
                Card(
                    color: myAppTheme.cardColor,
                    margin: myAppTheme.cardTheme.margin,
                    shape: myAppTheme.cardTheme.shape,
                    elevation: 6,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      //Login ID
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //Title
                            Text(
                              "Theme",
                              style: myAppTheme.textTheme.caption,
                            ),

                            //Option
                            DropdownButton<String>(
                              //TODO: Have a look at the color of the dropdown
                              iconEnabledColor: myAppTheme.iconTheme.color,
                              value: userProfile.containsKey("Theme") && userProfile["Theme"] != null
                                  ? userProfile["Theme"]
                                  : null,
                              hint: Text("Theme", style: myAppTheme.textTheme.body2, textAlign: TextAlign.center),
                              items: ["Dark Theme", "Light Theme"].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value, style: myAppTheme.textTheme.body2),
                                );
                              }).toList(),
                              style: myAppTheme.textTheme.body2,
                              onChanged: (String val) async {
                                showSnackBar(scaffoldKey: _scaffoldKey, text: "Please wait, saving...");

                                //Set the value
                                setState(() => userProfile["Theme"] = val);

                                //Update the theme
                                if (userProfile.containsKey("Theme"))
                                  myAppTheme = userProfile["Theme"] == "Light Theme"
                                      ? getMainThemeWithBrightness(context, Brightness.light)
                                      : getMainThemeWithBrightness(context, Brightness.dark);

                                //Save data to the database
                                if (await authService.setData())
                                  setState(() {});
                                else
                                  showSnackBar(scaffoldKey: _scaffoldKey, text: "Error saving!");
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Text(
                          "Choose your theme",
                          style: myAppTheme.textTheme.body2,
                        ),
                      ),
                    ])),
              ],
            )),
      ),
    );
  }
}
