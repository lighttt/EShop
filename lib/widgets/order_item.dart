import 'dart:math';
import 'package:flutter/material.dart';
import 'package:eshop/provider/order_provider.dart' as oi;

class OrderItem extends StatefulWidget {
  final oi.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$ ${widget.order.amount}"),
            subtitle: Text("${widget.order.dateTime.toString()}"),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10.0, 180),
              child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text('${prod.quanity} * \$ ${prod.price}',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 18))
                            ],
                          ))
                      .toList()),
            )
        ],
      ),
    );
  }
}
