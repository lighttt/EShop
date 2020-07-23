import 'package:flutter/material.dart';
import 'package:eshop/provider/order_provider.dart' as oi;

class OrderItem extends StatelessWidget {
  final oi.OrderItem order;
  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$ ${order.amount}"),
            subtitle: Text("${order.dateTime.toString()}"),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
