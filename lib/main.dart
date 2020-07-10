import 'package:eshop/provider/products.dart';
import 'package:eshop/screens/product_details_screen.dart';
import 'package:eshop/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Shop',
        theme: ThemeData(
            primaryColor: Colors.green,
            accentColor: Colors.red,
            fontFamily: "Lato"),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen()
        },
      ),
    );
  }
}
