import 'package:eshop/model/product.dart';
import 'package:flutter/cupertino.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "First",
      title: "Watch",
      price: 2000,
      description: "The best watch you will ever find.",
      imageURL:
          "https://www.surfstitch.com/on/demandware.static/-/Sites-ss-master-catalog/default/dwef31ef54/images/MBB-M43BLK/BLACK-WOMENS-ACCESSORIES-ROSEFIELD-WATCHES-MBB-M43BLK_1.JPG",
      isFavourite: false,
    ),
    Product(
        id: "second",
        title: "Shoes",
        price: 1500,
        description: "Quality and comfort shoes with fashionable style.",
        imageURL:
            "https://assets.adidas.com/images/w_600,f_auto,q_auto:sensitive,fl_lossy/e06ae7c7b4d14a16acb3a999005a8b6a_9366/Lite_Racer_RBN_Shoes_White_F36653_01_standard.jpg",
        isFavourite: false),
    Product(
        id: "third",
        title: "Laptop",
        price: 80000,
        description: "The compact and powerful gaming laptop under the budget.",
        imageURL:
            "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/h57/hdd/9010331451422/razer-blade-pro-hero-mobile.jpg",
        isFavourite: false),
    Product(
        id: "four",
        title: "T-Shirt",
        price: 1000,
        description: "A red color tshirt you can wear at any occassion.",
        imageURL:
            "https://5.imimg.com/data5/LM/NA/MY-49778818/mens-round-neck-t-shirt-500x500.jpg",
        isFavourite: false),
  ];

  // list return tara it cannnot be changed; can only be read
  List<Product> get items {
    return [..._items];
  }

  //function: to by product by id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
