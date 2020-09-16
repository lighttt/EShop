import 'package:eshop/provider/products_provider.dart';
import 'package:eshop/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        itemCount: searchItems.length,
        itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                ListTile(
                  title: Text(searchItems[index].title),
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                        arguments: searchItems[index].id);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(searchItems[index].imageURL),
                  ),
                ),
                Divider()
              ],
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Search product items"),
              )
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            itemCount: searchItems.length,
            itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(searchItems[index].title),
                      onTap: () {
                        Navigator.pushNamed(
                            context, ProductDetailsScreen.routeName,
                            arguments: searchItems[index].id);
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(searchItems[index].imageURL),
                      ),
                    ),
                    Divider()
                  ],
                ));
  }
}
