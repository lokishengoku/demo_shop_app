import 'dart:ui';

import 'package:demo_shop_app/providers/auth.dart';
import 'package:demo_shop_app/providers/cart.dart';
import 'package:demo_shop_app/providers/orders.dart';
import 'package:demo_shop_app/providers/products.dart';
import 'package:demo_shop_app/screens/auth_screen.dart';
import 'package:demo_shop_app/screens/cart_screen.dart';
import 'package:demo_shop_app/screens/edit_product_screen.dart';
import 'package:demo_shop_app/screens/orders_screen.dart';
import 'package:demo_shop_app/screens/product_detail_screen.dart';
import 'package:demo_shop_app/screens/products_overview_screen.dart';
import 'package:demo_shop_app/screens/splash_screen.dart';
import 'package:demo_shop_app/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, previusProducts) => Products(
            auth.token,
            auth.userId,
            previusProducts!.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previusOrders) => Orders(
            auth.token,
            auth.userId,
            previusOrders!.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: Colors.purple,
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
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          // initialRoute: '/',
          routes: {
            // '/': (ctx) => AuthScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
