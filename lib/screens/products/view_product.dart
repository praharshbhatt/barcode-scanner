import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mera_store/widgets/appbar.dart';
import '../../main.dart';

//==================This is the Homepage for the app==================

class ViewProductScreen extends StatefulWidget {
  Map mapProduct = new Map();

  ViewProductScreen(this.mapProduct);

  @override
  _ViewProductScreenState createState() => new _ViewProductScreenState(mapProduct);
}

class _ViewProductScreenState extends State<ViewProductScreen> with TickerProviderStateMixin {
  Map mapProduct = new Map();

  _ViewProductScreenState(this.mapProduct);

  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //For Displaying Product Photos
  List lstPhotos = new List();

  //Initialize
  @override
  void initState() {
    if (mapProduct.containsKey("photo url")) lstPhotos.addAll(mapProduct["photo url"]);

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
          strAppBarTitle: mapProduct["name"],
          showBackButton: true,
        ),

        //Body
        body: ListView(
          children: <Widget>[
            //Picture
            lstPhotos.length > 0
                ? CarouselSlider(
                    height: 400,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: Duration(seconds: 10),
                    enlargeCenterPage: true,
                    items: lstPhotos.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(i);
                        },
                      );
                    }).toList(),
                  )
                : Icon(
                    Icons.category,
                    color: myAppTheme.iconTheme.color,
                  ),

            //Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                mapProduct["name"],
                style: myAppTheme.textTheme.caption,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),

            //Model
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(mapProduct["model"],
                  style: myAppTheme.textTheme.body1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
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

//            //Quantity
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text("Quantity: " + mapProducts.values.elementAt(index).toString(),
//                  style: myAppTheme.textTheme.body1.copyWith(fontWeight: FontWeight.bold),
//                  overflow: TextOverflow.ellipsis,
//                  textAlign: TextAlign.right),
//            ),
          ],
        ),
      ),
    );
  }
}
