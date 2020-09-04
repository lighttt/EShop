import 'package:eshop/provider/order_provider.dart' show Orders;
import 'package:eshop/widgets/app_drawer.dart';
import 'package:eshop/widgets/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "/order_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.hasData
                  ? ListView.builder(
                      itemBuilder: (ctx, index) =>
                          OrderItem(snapshot.data[index]),
                      itemCount: snapshot.data.length == null
                          ? 0
                          : snapshot.data.length,
                    )
                  : Center(child: Text("No orders found!"));
        },
      ),
    );
  }
}
