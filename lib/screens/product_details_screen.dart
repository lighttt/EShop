import 'package:eshop/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = "/details_screen";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct = Provider.of<Products>(context).findById(id);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(selectedProduct.title),
            background: Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: "product${selectedProduct.id}",
                child: Image.network(
                  selectedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 15.0,
          ),
          Text(
            '\$ ${selectedProduct.price}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            selectedProduct.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            softWrap: true,
          ),
          SizedBox(
            height: 700,
          )
        ])),
      ]),
    );
  }
}
