import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit_product_screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Title"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
            ),
            TextFormField(
              focusNode: _priceFocusNode,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descFocusNode);
              },
            ),
            TextFormField(
                focusNode: _descFocusNode,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Description")),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 15, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                ),
                Expanded(
                    child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(labelText: "Image Url")))
              ],
            )
          ],
        ),
      ),
    );
  }
}
