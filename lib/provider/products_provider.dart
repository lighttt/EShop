import 'package:eshop/exception/httpexecption.dart';
import 'package:eshop/helper/API.dart';
import 'package:eshop/model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String _authToken;
  final String _userId;

  Products(this._authToken, this._userId, this._items);

  List<Product> _items = [];

  // list return tara it cannnot be changed; can only be read
  List<Product> get items {
    return [..._items];
  }

  //favourite list
  List<Product> get favourites {
    return _items.where((product) => product.isFavourite).toList();
  }

  //function: to by product by id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //add new product
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(API.Products + "?auth=$_authToken",
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'creatorId': _userId
          }));
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageURL: product.imageURL);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List<Product>> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filterByString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : "";

      final response = await http
          .get(API.Products + "?auth=$_authToken" + "&$filterByString");
      print(API.Products + "?auth=$_authToken" + "&$filterByString");
      print(response.toString());
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      //favourite api
      final favouriteResponse = await http
          .get(API.toggleFavourite + "$_userId.json" + "?auth=$_authToken");
      final favouriteData = json.decode(favouriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price'].toString()),
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageURL: prodData['imageURL'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      return loadedProducts;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //update the previous product
  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url = API.ProductByID + "$id.json" + "?auth=$_authToken";
        final response = await http.patch(url,
            body: json.encode({
              'title': updatedProduct.title,
              'price': updatedProduct.price,
              'description': updatedProduct.description,
              'imageURL': updatedProduct.imageURL,
            }));
        _items[prodIndex] = updatedProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //delete the product
  Future<void> deleteProduct(String id) async {
    final url = API.ProductByID + "$id.json" + "?auth=$_authToken";
    //first get the product for safe deleting
    // temp product
    int existingIndex = _items.indexWhere((prod) => prod.id == id);
    Product existingProduct = _items[existingIndex];
    //removing from list
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      //so firebase could not delete the product
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not be deleted! Try Again");
    } else {
      existingProduct = null;
    }
  }
}
