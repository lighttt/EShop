import 'dart:convert';

import 'package:eshop/helper/API.dart';
import 'package:eshop/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String _authToken;
  final String _userId;

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  //adding items to order
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = API.Orders + "$_userId.json" + "?auth=$_authToken";
    print(url);
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quanity,
                      'price': cp.price,
                      'title': cp.title
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //fetching the orders
  Future<List<OrderItem>> fetchAndSetOrders() async {
    final url = API.Orders + "$_userId.json" + "?auth=$_authToken";
    print(url);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return [];
      }
      print(extractedData.toString());
      final List<OrderItem> _loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: double.parse(item['price'].toString()),
                    quanity: item['quantity'],
                    title: item['title']))
                .toList(),
            dateTime: DateTime.parse(orderData["dateTime"])));
      });
      _orders = _loadedOrders;
      return _loadedOrders;
    } catch (error) {
      throw (error);
    }
  }
}
