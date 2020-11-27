import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/product_editor_screen.dart';

class UserProductItem extends StatefulWidget {
  final Product item;

  UserProductItem(this.item);

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(widget.item.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.item.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductEditorScreen.routeName,
                    arguments: widget.item);
              },
              color: Theme.of(context).primaryColor,
            ),
            _isDeleting
                ? FittedBox(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ))
                : IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _isDeleting = true;
                      });
                      Provider.of<Products>(context, listen: false)
                          .deleteProduct(widget.item.id)
                          .catchError((error) {
                        scaffold.showSnackBar(SnackBar(
                          content: Text('Failed to delete'),
                          duration: Duration(seconds: 2),
                        ));
                      }).then((value) => setState(() => _isDeleting = false));
                    },
                    color: Theme.of(context).errorColor,
                  )
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }
}
