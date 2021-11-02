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
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String productTitle, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (value) {
        return CartItem(
            id: productId,
            title: productTitle,
            quantity: value.quantity + 1,
            price: value.price + price);
      });
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId, title: productTitle, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity - 1));
    } else {
      _items.remove(id);
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});

  CartItem.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json['title'],
        quantity = json['quantity'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}
