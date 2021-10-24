import 'dart:ui';

import 'package:demo_shop_app/providers/cart.dart';
import 'package:demo_shop_app/providers/products.dart';
import 'package:demo_shop_app/screens/product_detail_screen.dart';
import 'package:demo_shop_app/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                color: Colors.black,
              ),
              headline6: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
        // home: ProductsOverviewScreen(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
