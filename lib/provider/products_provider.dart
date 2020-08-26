import 'package:eshop/exception/httpexecption.dart';
import 'package:eshop/helper/API.dart';
import 'package:eshop/model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: "First",
//      title: "Watch",
//      price: 2000,
//      description: "The best watch you will ever find.",
//      imageURL:
//          "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
//      isFavourite: false,
//    ),
//    Product(
//        id: "second",
//        title: "Shoes",
//        price: 1500,
//        description: "Quality and comfort shoes with fashionable style.",
//        imageURL:
//            "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
//        isFavourite: false),
//    Product(
//        id: "third",
//        title: "Laptop",
//        price: 80000,
//        description: "The compact and powerful gaming laptop under the budget.",
//        imageURL:
//            "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/h57/hdd/9010331451422/razer-blade-pro-hero-mobile.jpg",
//        isFavourite: false),
//    Product(
//        id: "four",
//        title: "T-Shirt",
//        price: 1000,
//        description: "A red color tshirt you can wear at any occassion.",
//        imageURL:
//            "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
//        isFavourite: false),
  ];

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
  Future<void> addProduct(Product product) {
    return http
        .post(API.Products,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageURL': product.imageURL,
              'isFavourite': product.isFavourite
            }))
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageURL: product.imageURL);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw (error);
    });
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(API.Products);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price'].toString()),
          isFavourite: prodData['isFavourite'],
          imageURL: prodData['imageURL'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
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
        final url = API.ProductByID + "$id.json";
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
    final url = API.ProductByID + "$id.json";
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