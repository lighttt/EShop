import 'package:eshop/provider/auth_provider.dart';
import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/screens/product_overview_screen.dart';
import 'package:eshop/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Logout"),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
