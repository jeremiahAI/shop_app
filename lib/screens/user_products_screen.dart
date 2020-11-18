import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'product_editor_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static var routeName = "/user-products";

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Your products"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .pushNamed(ProductEditorScreen.routeName),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => Column(
              children: [UserProductItem(products.items[index]), Divider()],
            ),
            itemCount: products.items.length,
          ),
        ));
  }
}
