import 'package:eshop/provider/cart_provider.dart' show Cart;
import 'package:eshop/provider/order_provider.dart';
import 'package:eshop/screens/order_screen.dart';
import 'package:eshop/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart_screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OrderButton(cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) => CartItem(
                cartId: cart.items.keys.toList()[i],
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quanity,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await order.addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Text(
              "ORDER NOW",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor),
            ),
    );
  }
}
