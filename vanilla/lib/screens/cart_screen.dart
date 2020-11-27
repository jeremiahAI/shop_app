import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Your cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(orders: orders, cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  CartListItem(cart.items.values.toList()[index]),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.orders,
    @required this.cart,
  }) : super(key: key);

  final Orders orders;
  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _orderInProgress = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _orderInProgress
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
            ),
      onPressed: widget.cart.totalAmount <= 0 || _orderInProgress
          ? null
          : () {
              setState(() {
                _orderInProgress = true;
              });
              widget.orders
                  .addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              )
                  .then((value) {
                setState(() {
                  _orderInProgress = false;
                });
                widget.cart.clear();
              });
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
