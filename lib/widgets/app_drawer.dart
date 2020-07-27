import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Manish Tuladhar"),
            accountEmail: Text("manish.eclipse@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  "https://www.web-eau.net/images/overrides/avatars/avatar7.png"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Shop"),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          Divider()
        ],
      ),
    );
  }
}