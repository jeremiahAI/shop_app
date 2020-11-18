import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_editor_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product item;

  UserProductItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(item.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductEditorScreen.routeName, arguments: item);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
