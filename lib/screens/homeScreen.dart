import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/screens/products/view_product.dart';
import 'package:mera_store/services/auth.dart';
import 'package:mera_store/themes/stepper_switch.dart';
import 'package:mera_store/widgets/appbar.dart';
import 'package:mera_store/widgets/buttons.dart';
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

  Map mapProducts = new Map();

  //Initialize
  @override
  void initState() {
    if (userProfile.containsKey("Unordered Products")) mapProducts = userProfile["Unordered Products"];

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
              if (mapProducts.containsKey(barcode)) {
                //Increase count
                setState(() {
                  mapProducts[barcode] = ++mapProducts[barcode];
                });
              } else {
                //Add a new product
                setState(() {
                  mapProducts[barcode] = 1;
                });
              }
              userProfile["Unordered Products"] = mapProducts;

              //Update the new Unordered Products list to the Firebase CLoud Firestpre
              await authService.setData();
            }
          },
        ),

        //Body
        body: mapProducts != null && mapProducts.length > 0
            ? Container(
                child: Column(
                  children: <Widget>[
                    //Products in Cart List
                    getUnorderedProducts(size),

                    //Final invoice
                    getInvoice(size),

                    //Checkout Button
                    getCheckoutButton(size),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/empty-cart.png",
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      "No Items Added.\nPlease Add items by scanning them",
                      style: myAppTheme.textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //Get the list of all the Orders still in Cart
  getUnorderedProducts(double size) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
          itemCount: mapProducts.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot == null || snapshot.data == null || snapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(myAppTheme.primaryColor),
                      strokeWidth: 5,
                    ),
                  );
                } else {
                  Map mapProduct = snapshot.data;

                  return GestureDetector(
                    child: Card(
                      elevation: myAppTheme.cardTheme.elevation,
                      color: myAppTheme.cardTheme.color,
                      shape: myAppTheme.cardTheme.shape,
                      child: Row(
                        children: <Widget>[
                          mapProduct.containsKey("photo url")
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(width: 120, child: Image.network(mapProduct["photo url"][0])))
                              : Icon(
                                  Icons.category,
                                  color: myAppTheme.iconTheme.color,
                                ),
                          Container(
                            width: size - 150,
                            child: Column(
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

                                //Model
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(mapProduct["model"],
                                      style: myAppTheme.textTheme.body1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right),
                                ),

                                //Description
//                              Container(
//                                width: MediaQuery.of(context).size.width - 150,
//                                padding: EdgeInsets.all(15),
//                                child: Text(mapProduct["description"],
//                                    style: myAppTheme.textTheme.body2,
//                                    overflow: TextOverflow.ellipsis,
//                                    maxLines: 3,
//                                    textAlign: TextAlign.right),
//                              ),

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

                                //Quantity
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  height: 60,
                                  child: StepperTouch(
                                    initialValue: mapProducts.values.elementAt(index),
                                    direction: Axis.horizontal,
                                    withSpring: true,
                                    primaryColor: myAppTheme.accentColor,
                                    textColor: myAppTheme.textTheme.bodyText1.color,
                                    onChanged: (int value) {
                                      if (value == 0) {
                                        setState(() {
                                          mapProducts.remove(mapProducts.keys.elementAt(index));
                                        });
                                      } else if (value > 0) {
                                        setState(() {
                                          mapProducts[mapProducts.keys.elementAt(index)] = value;
                                        });
                                      }

                                      userProfile["Unordered Products"] = mapProducts;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Open
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewProductScreen(mapProduct)),
                      );
                    },
                  );
                }
              },
              future: getProduct(mapProducts.keys.elementAt(index)),
            );
          }),
    );
  }

  //Get the Total Price and the Total discount
  getInvoice(double size) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot == null || snapshot.data == null || snapshot.hasData == false) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(myAppTheme.primaryColor),
              strokeWidth: 5,
            ),
          );
        } else {
          Map mapProduct = snapshot.data;

          double dbTotalDiscount = mapProduct["discount"], dbTotalPrice = mapProduct["price"];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              //Total Discount
//              Padding(
//                padding: const EdgeInsets.fromLTRB(0, 20, 10, 5),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    Text(
//                      "Total Discount:   ",
//                      style: myAppTheme.textTheme.body1,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                    Text(
//                      dbTotalDiscount.toString(),
//                      style: myAppTheme.textTheme.body1,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ],
//                ),
//              ),

              //Total Price
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Total Price:   ",
                      style: myAppTheme.textTheme.body1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      dbTotalPrice.toString(),
                      style: myAppTheme.textTheme.body1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
      future: getInvoiceDetails(),
    );
  }

  getInvoiceDetails() async {
    double dbTotalDiscount = 0.0, dbTotalPrice = 0.0;

    //Loop through all the products to get the Discount and the Price
    await Future.forEach(mapProducts.keys, (key) async {
      String strProductID = key;
      Map mapProduct = await getProduct(strProductID);

      if (mapProduct.containsKey("discount"))
        dbTotalDiscount += double.tryParse((mapProduct["discount"] * mapProducts[key]).toString());
      if (mapProduct.containsKey("price"))
        dbTotalPrice += double.tryParse((mapProduct["price"] * mapProducts[key]).toString());
//      print("discount: " + dbTotalDiscount.toString());
//      print("price: " + dbTotalPrice.toString());
    });

    return {"discount": dbTotalDiscount, "price": dbTotalPrice};
  }

  //Get Checkout button
  getCheckoutButton(double size) {
    return ButtonTheme(
      minWidth: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 20, 80, 10),
        child: primaryRaisedButton(
          context: context,
          text: "Proceed to Checkout",
          color: myAppTheme.primaryColor,
          onPressed: () {
            //Go to Checkout
          },
        ),
      ),
    );
  }

  //=================================================================================
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
