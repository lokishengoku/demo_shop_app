import 'dart:convert';

import 'package:demo_shop_app/models/http_exception.dart';
import 'package:demo_shop_app/providers/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;

  Products(this.authToken, this._items);

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
        'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((key, value) {
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
          'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');

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

  Future<void> updateProduct(Product newProduct) async {
    final prodIndex =
        _items.indexWhere((element) => element.id == newProduct.id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products/${newProduct.id}.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-demo-6b516-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('couldn\'t delete product');
    } else {
      existingProduct.dispose();
    }
  }
}
