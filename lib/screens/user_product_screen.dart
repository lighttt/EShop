import 'package:eshop/provider/products.dart';
import 'package:eshop/widgets/app_drawer.dart';
import 'package:eshop/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/user_product_screen";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          itemCount: productsData.length,
          itemBuilder: (ctx, index) => UserProductItem(
                id: productsData[index].id,
                title: productsData[index].title,
                imageUrl: productsData[index].imageURL,
              )),
    );
  }
}
