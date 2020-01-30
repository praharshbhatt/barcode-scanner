import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/widgets/appbar.dart';
import 'package:mera_store/widgets/dialogboxes.dart';
import 'package:mera_store/widgets/drawer.dart';
import '../main.dart';
import '../themes/maintheme.dart';

//==================This is the Homepage for the app==================

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List lstProducts = new List();

  //Initialize
  @override
  void initState() {
    if (userProfile.containsKey("Unordered Products")) lstProducts.addAll(userProfile["Unordered Products"]);

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

    //For Refreshing the theme
    if (userProfile.containsKey("Theme"))
      myAppTheme = userProfile["Theme"] == "Light Theme"
          ? getMainThemeWithBrightness(context, Brightness.light)
          : getMainThemeWithBrightness(context, Brightness.dark);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: myAppTheme.scaffoldBackgroundColor,
        appBar: getAppBar(
          scaffoldKey: scaffoldKey,
          context: context,
          strAppBarTitle: "Mera Store",
          showBackButton: false,
        ),
        //drawer
        drawer: getDrawer(context, scaffoldKey),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: myAppTheme.iconTheme.color),
          backgroundColor: myAppTheme.primaryColor,
          onPressed: () async {
            String barcode = await scan();
            if (barcode != null && barcode != "") {
              setState(() {
                lstProducts.add(barcode);
              });
              userProfile["Unordered Products"] = lstProducts;

              //Update the new Unordered Products list to the Firebase CLoud Firestpre
              await authService.setData();
            }
          },
        ),

        //Body
        body: getUnorderedProducts(),
      ),
    );
  }

  getUnorderedProducts() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: lstProducts.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot == null || snapshot.data == null || snapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(myAppTheme.accentColor),
                      strokeWidth: 5,
                    ),
                  );
                } else {
                  Map mapProduct = snapshot.data;

                  return Card(
                    elevation: myAppTheme.cardTheme.elevation,
                    color: myAppTheme.cardTheme.color,
                    shape: myAppTheme.cardTheme.shape,
                    child: (Row(
                      children: <Widget>[
                        mapProduct.containsKey("photo url")
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(width: 120, child: Image.network(mapProduct["photo url"][0])))
                            : Icons.category,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            //Title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                mapProduct["name"],
                                style: myAppTheme.textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),

                            //model
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(mapProduct["model"],
                                  style: myAppTheme.textTheme.body1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right),
                            ),

                            //Description
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              padding: EdgeInsets.all(15),
                              child: Text(mapProduct["description"],
                                  style: myAppTheme.textTheme.body2,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.right),
                            ),

                            //Discount
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Discount: " + mapProduct["discount"].toString() + "%",
                                  style: myAppTheme.textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right),
                            ),
                            //Price
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Price: " + mapProduct["price"].toString(),
                                  style: myAppTheme.textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right),
                            ),
                          ],
                        )
                      ],
                    )),
                  );
                }
              },
              future: getProduct(lstProducts[index]),
            );
          }),
    );
  }

  //Get details of product
  Future<Map<String, dynamic>> getProduct(String barcode) async {
    return (await Firestore.instance.collection("Products").document(barcode).get()).data;
  }

  //Scan QR code
  Future<String> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showSnackBar(scaffoldKey: scaffoldKey, text: "The user did not grant the camera permission!");
      } else {
        showSnackBar(scaffoldKey: scaffoldKey, text: "Unknown error: $e");
      }

      return null;
    } on FormatException {
      showSnackBar(
          scaffoldKey: scaffoldKey,
          text: 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      showSnackBar(scaffoldKey: scaffoldKey, text: "nknown error: $e");
    }
    return null;
  }
}
