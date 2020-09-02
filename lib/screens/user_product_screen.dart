import 'package:eshop/provider/products_provider.dart';
import 'package:eshop/widgets/app_drawer.dart';
import 'package:eshop/widgets/user_product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/user_product_screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Products>(
                  builder: (ctx, products, _) => ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      itemCount: products.items.length,
                      itemBuilder: (ctx, index) => UserProductItem(
                            id: products.items[index].id,
                            title: products.items[index].title,
                            imageUrl: products.items[index].imageURL,
                          )),
                );
        },
      ),
    );
  }
}
