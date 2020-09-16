import 'package:eshop/helper/custom_route.dart';
import 'package:eshop/provider/cart_provider.dart';
import 'package:eshop/provider/products_provider.dart';
import 'package:eshop/screens/cart_screen.dart';
import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/widgets/app_drawer.dart';
import 'package:eshop/widgets/badge.dart';
import 'package:eshop/widgets/custom_search_delegate.dart';
import 'package:eshop/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//show or not show favourites
enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = "/product_overview_screen";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourites = false;

  @override
  Widget build(BuildContext context) {
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
              PopupMenuItem(value: FilterOptions.All, child: Text("Show All")),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return Badge(value: cart.itemCount.toString(), child: child);
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context)
                    .push(CustomRoute(builder: (ctx) => CartScreen()));
                // Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ProductGrid(_showFavourites),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
