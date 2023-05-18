import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/data/model/product.dart';
import 'package:hello_flutter/data/repository/product_repository_impl.dart';

import '../service/auth_service.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  var _title = "";
  var _titleError = "";

  var _brand = "";
  var _brandError = "";

  var _category = "";
  var _categoryError = "";

  var _description = "";
  var _descriptionError = "";

  var _price = 0.0;

  var _discount = 0.0;

  var _rating = 0.0;

  var _stock = 0;

  final repo = ProductRepositoryImpl();

  @override
  void initState() {
    super.initState();

  }

  Future getProductById()

  _onTitleChanged(value) {
    setState(() {
      _title = value;
    });
  }

  _onBrandChanged(value) {
    setState(() {
      _brand = value;
    });
  }

  _onCategoryChanged(value) {
    setState(() {
      _category = value;
    });
  }

  _onDescriptionChanged(value) {
    setState(() {
      _description = value;
    });
  }

  _onPriceChanged(value) {
    setState(() {
      _price = value;
    });
  }

  _onDiscountChanged(value) {
    setState(() {
      _discount = value;
    });
  }

  _onRatingChanged(value) {
    setState(() {
      _rating = value;
    });
  }

  _onStockChanged(value) {
    setState(() {
      _stock = value;
    });
  }

  Future _createProduct(Product product) async {
    await repo.insertItem(product);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Future _onCreateClick() async {
    setState(() {
      if (_title.isEmpty) {
        _titleError = "This field cannot be empty";
        return;
      } else {
        _titleError = "";
      }

      if (_brand.isEmpty) {
        _brandError = "This field cannot be empty";
        return;
      } else {
        _brandError = "";
      }

      if (_category.isEmpty) {
        _categoryError = "This field cannot be empty";
        return;
      } else {
        _categoryError = "";
      }

      if (_description.isEmpty) {
        _descriptionError = "This field cannot be empty";
        return;
      } else {
        _descriptionError = "";
      }

      final product = Product(title: _title, brand: _brand, category: _category, description: _description, price: _price, discountPercentage: _discount, rating: _rating, stock: _stock);
      _createProduct(product);
      debugPrint("$_title $_description");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create Task"),
        // centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 200,
                color: Colors.grey.shade500,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                  onChanged: (value) => { _onTitleChanged(value).isDefinedAndNotNull ? _onTitleChanged(value) : },
                  decoration: InputDecoration(
                      hintText: "Title",
                      errorText: _titleError.isEmpty ? null : _titleError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                  onChanged: (value) => {_onBrandChanged(value)},
                  decoration: InputDecoration(
                      hintText: "Brand",
                      errorText: _brandError.isEmpty ? null : _brandError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                  onChanged: (value) => {_onCategoryChanged(value)},
                  decoration: InputDecoration(
                      hintText: "Category",
                      errorText: _categoryError.isEmpty ? null : _categoryError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                  onChanged: (value) => {_onDescriptionChanged(value)},
                  decoration: InputDecoration(
                      hintText: "Description",
                      errorText: _descriptionError.isEmpty
                          ? null
                          : _descriptionError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                      onChanged: (value) => { _onPriceChanged(double.tryParse(value))},
                      decoration: InputDecoration(
                        labelText: "Enter your price",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ]
                  )
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                      onChanged: (value) => { _onDiscountChanged(double.tryParse(value))},
                      decoration: InputDecoration(
                        labelText: "Enter your discount",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ]
                  )
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                      onChanged: (value) => { _onRatingChanged(double.tryParse(value))},
                      decoration: InputDecoration(
                        labelText: "Enter your rating",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                      ]
                  )
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextField(
                      onChanged: (value) => { _onStockChanged(int.tryParse(value))},
                      decoration: InputDecoration(
                        labelText: "Enter your stock quantity",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ElevatedButton(
                      onPressed: () => _onCreateClick(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text(
                        "Create",
                        style: TextStyle(fontSize: 24),
                      )
                  )
              ),
            ]
        ),
      ),
    );
  }
}
