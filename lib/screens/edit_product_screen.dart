import 'package:eshop/model/product.dart';
import 'package:eshop/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit_product_screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //focusnode
  final _descFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  //form
  final _form = GlobalKey<FormState>();

  //controller
  TextEditingController _imgController = TextEditingController();

  //values
  Product _editProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageURL: "",
  );

  //bool to get data only for the first
  bool _isInit = true;

  var _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageURL": "",
  };

  @override
  void initState() {
    super.initState();
    _imgController.addListener(updateImageUrl);
  }

  // helps us to get the route arguments
  // its is called time to time so we get id and initialize value only once
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          "title": _editProduct.title,
          "price": _editProduct.price.toString(),
          "description": _editProduct.description,
          "imageURL": "",
        };
        _imgController.text = _editProduct.imageURL;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgController.dispose();
    _imageFocusNode.dispose();
  }

  //updates the image in the container
  void updateImageUrl() {
    String value = _imgController.text;
    if (!_imageFocusNode.hasFocus) {
      if (!value.startsWith('http') && !value.startsWith("https") ||
          !value.endsWith('.png') &&
              !value.endsWith(".jpg") &&
              !value.endsWith(".jpeg") &&
              !value.endsWith("JPEG")) {
        return;
      }
      setState(() {});
    }
  }

  //save form and add product or edit product
  void _saveForm() {
    //validation check
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editProduct.id == null ? "Add Product" : "Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(labelText: "Title"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "The title must not be empty";
                }
                if (!value.contains(new RegExp("^[a-zA-Z]+\$"), 0)) {
                  return "You cannot insert 0-9 here.";
                }
                return null;
              },
              onSaved: (value) {
                _editProduct = Product(
                  title: value,
                  description: _editProduct.description,
                  id: _editProduct.id,
                  imageURL: _editProduct.imageURL,
                  price: _editProduct.price,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              focusNode: _priceFocusNode,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "The price must not be empty";
                }
                if (double.tryParse(value) == null) {
                  return "The price should be in number format";
                }
                if (double.parse(value) <= 0) {
                  return 'The price should not  be less than zero';
                }
                return null;
              },
              onSaved: (value) {
                _editProduct = Product(
                  title: _editProduct.title,
                  description: _editProduct.description,
                  id: _editProduct.id,
                  imageURL: _editProduct.imageURL,
                  price: double.parse(value),
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              focusNode: _descFocusNode,
              maxLines: 3,
              decoration: InputDecoration(labelText: "Description"),
              validator: (value) {
                if (value.isEmpty) {
                  return "The desciprtion must not be empty";
                }
                if (value.length < 10) {
                  return "The description is too short";
                }
                return null;
              },
              onSaved: (value) {
                _editProduct = Product(
                  title: _editProduct.title,
                  description: value,
                  id: _editProduct.id,
                  imageURL: _editProduct.imageURL,
                  price: _editProduct.price,
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 15, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: _imgController.text.isEmpty
                      ? Center(child: Text("Enter a url"))
                      : Image.network(_imgController.text),
                ),
                Expanded(
                    child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        focusNode: _imageFocusNode,
                        decoration: InputDecoration(labelText: "Image Url"),
                        controller: _imgController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The image url must not be empty";
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith("https")) {
                            return "The image url is not valid";
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith(".jpg") &&
                              !value.endsWith(".jpeg") &&
                              !value.endsWith("JPEG")) {
                            return "The image url is not correct";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            title: _editProduct.title,
                            description: _editProduct.description,
                            id: _editProduct.id,
                            imageURL: value,
                            price: _editProduct.price,
                          );
                        }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
