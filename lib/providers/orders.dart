import 'dart:convert';

import 'package:demo_shop_app/providers/cart.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchAndSetOrders() async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      } else {
        final List<OrderTtem> loadedProducts = [];

        (extractedData as Map<String, dynamic>).forEach((key, value) {
          loadedProducts.add(OrderTtem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: List<CartItem>.from(json
                .decode(value['products'])
                .map((e) => CartItem.fromJson(e))),
          ));
        });

        _orders = loadedProducts.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': jsonEncode(cartProducts)
          }));
      print('yo 2');
      final addedOrder = OrderTtem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts);

      _orders.insert(0, addedOrder);
      print('yo 3');

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
