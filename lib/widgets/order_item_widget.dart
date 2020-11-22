import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({Key key, this.order}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height:
          expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    // transitionBuilder: (child, animation) {
                    //   return RotationTransition(
                    //     turns: animation,
                    //     child: child,
                    //   );
                    // },
                    child: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      key: ValueKey(expanded),
                    )),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              curve: Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: min(widget.order.products.length * 20.0 + 10, 100),
                  child: ListView(
                    children: widget.order.products
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${prod.quantity} x \$${prod.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
