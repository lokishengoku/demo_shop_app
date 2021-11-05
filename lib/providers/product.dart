import 'dart:convert';

import 'package:demo_shop_app/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteState(String authToken) async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');

    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('couldn\'t toggle favorite this product');
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
