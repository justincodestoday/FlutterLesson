import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../model/product.dart';
import 'package:http/http.dart' as http;

class ProductRepositoryImpl {
  Future<List<Product>> getProducts() async {
    final res = await http.get(
      Uri.parse("https://product-catalog-backend.onrender.com/products")
    );

    if (res.statusCode == 200) {
      // debugPrint(res.body);

      // Another method to get the products to become a list
      // var body = jsonDecode(res.body);
      // final products = <Product>[];
      // for(final item in body) {
      //   products.add(Product.fromMap(item));
      // }

      List<Product> products = List<Product>.from(jsonDecode(res.body).map((item) => Product.fromMap(item)));
      return products;
    } else {
      throw Exception("Failed to load");
    }
  }

  Future insertItem(Product product) async {
    final res = await http.post(
        Uri.parse("https://product-catalog-backend.onrender.com/products"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(product.toMap())
    );

    if (res.statusCode == 200) {
      // return jsonDecode(res.body)["id"] ?? -1;
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to insert");
    }
  }

  Future deleteItem(String id) async {
    await http.delete(
      Uri.parse("https://product-catalog-backend.onrender.com/products/$id"),
    );
  }

  Future updateItem(String id, Product product) async {
    final res = await http.put(
        Uri.parse("https://product-catalog-backend.onrender.com/products/$id"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(product.toMap())
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["id"];
    } else {
      throw Exception("Failed to update");
    }
  }

  Future<Product> getProductById(String id) async {
    final res = await http.get(
        Uri.parse("https://product-catalog-backend.onrender.com/products/$id"),
    );

    if (res.statusCode == 200) {
      // debugPrint(res.body);
      Product product = Product.fromMap(jsonDecode(res.body));
      return product;
    } else {
      throw Exception("Failed to load");
    }
  }
}
