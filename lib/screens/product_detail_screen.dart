import 'package:demo_shop_app/models/product.dart';
import 'package:demo_shop_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            loadedProduct.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: Container());
  }
}
