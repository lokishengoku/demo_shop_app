import 'package:demo_shop_app/providers/orders.dart';
import 'package:demo_shop_app/widgets/app_drawer.dart';
import 'package:demo_shop_app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static final String routeName = '/orders-screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return OrderItem(order: orders.orders[index]);
        },
        itemCount: orders.orders.length,
      ),
    );
  }
}
