import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/widgets/appbar.dart';
import '../../main.dart';

//==================This is the Homepage for the app==================

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => new _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //Initialize
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: myAppTheme.scaffoldBackgroundColor,
        appBar: getAppBar(
          scaffoldKey: scaffoldKey,
          context: context,
          strAppBarTitle: "Mera Store",
          showBackButton: true,
        ),
        //drawer

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: myAppTheme.iconTheme.color),
          backgroundColor: myAppTheme.primaryColor,
          onPressed: () async {},
        ),

        //Body
        body: Container(),
      ),
    );
  }
}
