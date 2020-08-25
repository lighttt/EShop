import 'package:eshop/provider/order_provider.dart';
import 'package:eshop/provider/products_provider.dart';
import 'package:eshop/screens/cart_screen.dart';
import 'package:eshop/screens/edit_product_screen.dart';
import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/screens/product_details_screen.dart';
import 'package:eshop/screens/product_overview_screen.dart';
import 'package:eshop/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Shop',
        theme: ThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.red,
            fontFamily: "Lato"),
        home: ProductOverviewScreen(),
        routes: {
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}
