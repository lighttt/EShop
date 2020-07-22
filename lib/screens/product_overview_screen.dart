import 'package:eshop/model/product.dart';
import 'package:eshop/provider/cart_provider.dart';
import 'package:eshop/provider/products.dart';
import 'package:eshop/screens/cart_screen.dart';
import 'package:eshop/widgets/badge.dart';
import 'package:eshop/widgets/product_grid.dart';
import 'package:eshop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  //show or not show favourites
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourites = false;

  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<Products>(context).items;
    return Scaffold(
        appBar: AppBar(
          title: Text("E-Shop"),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedOption) {
                setState(() {
                  if (selectedOption == FilterOptions.Favourites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: FilterOptions.Favourites,
                    child: Text("Show Favourites")),
                PopupMenuItem(
                    value: FilterOptions.All, child: Text("Show All")),
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) {
                return Badge(value: cart.itemCount.toString(), child: child);
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: ProductGrid(_showFavourites));
  }
}
