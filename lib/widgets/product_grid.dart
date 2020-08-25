import 'package:eshop/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourites;
  ProductGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final loadedProducts = showFavourites
        ? Provider.of<Products>(context).favourites
        : Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
