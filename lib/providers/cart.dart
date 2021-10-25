import 'package:flutter/widgets.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items != null ? _items.length : 0;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quanitity;
    });
    return total;
  }

  void addItem(String productId, String productTitle, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (value) {
        return CartItem(
            id: productId,
            title: productTitle,
            quanitity: value.quanitity + 1,
            price: value.price + price);
      });
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId, title: productTitle, quanitity: 1, price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quanitity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quanitity,
      required this.price});
}
