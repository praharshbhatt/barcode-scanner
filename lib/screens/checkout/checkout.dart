import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/widgets/appbar.dart';
import 'package:mera_store/widgets/dialogboxes.dart';
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
    completeOrder();

    super.initState();
  }

  //Update Order
  completeOrder() async {
    //Move the Unordered items to Ordered
//    showLoading(context);

    //1. Get the Un ordered Products
    Map mapOrdered = new Map();
    if (userProfile.containsKey("Ordered Products")) mapOrdered = userProfile["Ordered Products"];

    //Add the Un Ordered products in the Ordered Map
    mapOrdered[DateTime.now().toString()] = userProfile["Unordered Products"];

    //Update the userProfile
    userProfile["Ordered Products"] = mapOrdered;
    if (userProfile.containsKey("Unordered Products")) userProfile.remove("Unordered Products");

    await authService.setData();

//    Navigator.pop(context);
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
        backgroundColor: Colors.white.withOpacity(0.97),
        appBar: getAppBar(
          scaffoldKey: scaffoldKey,
          context: context,
          strAppBarTitle: "Order Complete",
          showBackButton: true,
        ),
        //Body
        body: ListView(
          children: <Widget>[
            Text(
              "Your Order is Complete\nThank you for Shopping with us!",
              style: myAppTheme.textTheme.caption.copyWith(color: Colors.black),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              "assets/animations/done.gif",
              fit: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
            ),


          ],
        ),
      ),
    );
  }
}
