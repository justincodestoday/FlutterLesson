import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/data/repository/product_repository_impl.dart';

import '../data/model/product.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    getProducts();
  }

  final repo = ProductRepositoryImpl();
  List<Product> products = [];

  Future getProducts() async {
    products = await repo.getProducts();
    notifyListeners();
  }
}