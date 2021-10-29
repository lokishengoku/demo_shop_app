import 'dart:convert';

import 'package:demo_shop_app/providers/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((element) => element.isFavorite == true)];
  }

  Product findById(String id) {
    return _items.firstWhere((ele) => ele.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedDate.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite
          }));

      final addedProduct = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          price: newProduct.price,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl);

      _items.add(addedProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(Product newProduct) {
    final prodIndex =
        _items.indexWhere((element) => element.id == newProduct.id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
