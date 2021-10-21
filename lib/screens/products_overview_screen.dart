import 'package:demo_shop_app/providers/product.dart';
import 'package:demo_shop_app/widgets/product_item.dart';
import 'package:demo_shop_app/widgets/products_grid.dart';
import 'package:flutter/material.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopee',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: ProductsGrid(),
    );
  }
}
