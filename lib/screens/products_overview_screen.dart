import 'package:demo_shop_app/providers/cart.dart';
import 'package:demo_shop_app/screens/cart_screen.dart';
import 'package:demo_shop_app/widgets/app_drawer.dart';
import 'package:demo_shop_app/widgets/badge.dart';
import 'package:demo_shop_app/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopee',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
                child: ch!,
                value: cart.itemCount.toString(),
                color: Theme.of(context).accentColor),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == FilterOptions.Favorites) {
                setState(() {
                  _showOnlyFavorite = true;
                });
              } else {
                setState(() {
                  _showOnlyFavorite = false;
                });
              }
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(showFavs: _showOnlyFavorite),
    );
  }
}
