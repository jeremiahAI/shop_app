import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductEditorScreen extends StatefulWidget {
  static var routeName = '/edit-product';

  @override
  _ProductEditorScreenState createState() => _ProductEditorScreenState();
}

class _ProductEditorScreenState extends State<ProductEditorScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;

  Product product;

  _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        isLoading = true;
      });

      final productsProvider = Provider.of<Products>(context, listen: false);

      if (product.id == null) {
        productsProvider.addProduct(product).then((_) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } else {
        productsProvider.updateProduct(product);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  var _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      var suppliedProduct =
          ModalRoute.of(context).settings.arguments as Product;
      product = suppliedProduct != null
          ? suppliedProduct
          : Product(
              id: null,
              title: "",
              description: "",
              imageUrl: "",
              price: 0,
            );

      _imageUrlController.text = product.imageUrl;
      _isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: product.title,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (val) {
                          product = product.copy(title: val);
                        },
                        validator: (String val) =>
                            val.isEmpty ? "Please enter a title." : null,
                      ),
                      TextFormField(
                        initialValue:
                            product.price == 0 ? "" : product.price.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (String val) => val.isEmpty
                            ? "Please enter an amount."
                            : double.tryParse(val) == null
                                ? "Please enter a valid amount"
                                : double.parse(val) <= 0
                                    ? "Please enter an greater than 0"
                                    : null,
                        onSaved: (val) {
                          product = product.copy(price: double.parse(val));
                        },
                      ),
                      TextFormField(
                        initialValue: product.description,
                        decoration: InputDecoration(labelText: "Description"),
                        // textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (String val) =>
                            val.isEmpty ? "Please enter a Description." : null,
                        onSaved: (val) {
                          product = product.copy(description: val);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 15, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text("Enter a URL"))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (_, __, ___) => Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (String val) => val.isEmpty
                                  ? "Please enter an image URL."
                                  : null,
                              onSaved: (val) {
                                product = product.copy(imageUrl: val);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }
}
