import 'package:demo_shop_app/providers/cart.dart';
import 'package:flutter/widgets.dart';

class OrderTtem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderTtem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderTtem> _orders = [];

  List<OrderTtem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderTtem(
            id: DateTime.now().toString(),
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}
