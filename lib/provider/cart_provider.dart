import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quanity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quanity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //item count
  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  //add items/products to the cart
  void addToCart(String productId, String title, double price) {
    //if hamro product pahila add bhacha bhane
    // just update the quantity of that product
    //else naya product ani naya product

    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quanity: existingCartItem.quanity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quanity: 1,
              ));
    }
    notifyListeners();
  }
}
