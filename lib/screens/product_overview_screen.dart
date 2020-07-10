import 'package:eshop/provider/products.dart';
import 'package:eshop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Shop"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (ctx, i) =>
            ProductItem(
              loadedProducts[i].id,
              loadedProducts[i].title, 
              loadedProducts[i].imageURL),
        itemCount: loadedProducts.length,
      ),
    );
  }
}
