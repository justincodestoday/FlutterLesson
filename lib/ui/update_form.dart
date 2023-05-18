import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/data/model/product.dart';
import 'package:hello_flutter/data/repository/product_repository_impl.dart';

class UpdateForm extends StatefulWidget {
  const UpdateForm({Key? key, required this.productId}) : super(key: key);

  final String productId;

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  Product? product;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductById();
  }

  final TextEditingController _titleController = TextEditingController();
  var _titleError = "";

  final TextEditingController _brandController = TextEditingController();
  var _brandError = "";

  final TextEditingController _categoryController = TextEditingController();
  var _categoryError = "";

  final TextEditingController _descriptionController = TextEditingController();
  var _descriptionError = "";

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _discountController = TextEditingController();

  final TextEditingController _ratingController = TextEditingController();

  final TextEditingController _stockController = TextEditingController();

  final repo = ProductRepositoryImpl();

  Future getProductById() async {
    debugPrint("Product ID ${widget.productId.toString()}");
    final singleProduct = await repo.getProductById(widget.productId);
    product = singleProduct;
    _titleController.text = product?.title ?? "";
    _brandController.text = product?.brand ?? "";
    _categoryController.text = product?.category ?? "";
    _descriptionController.text = product?.description ?? "";
    _priceController.text = product?.price.toString() ?? "";
    _discountController.text = product?.discountPercentage.toString() ?? "";
    _ratingController.text = product?.rating.toString() ?? "";
    _stockController.text = product?.stock.toString() ?? "";
  }

  Future _updateProduct(Product product) async {
    await repo.updateItem(widget.productId, product);
    setState(() {
      context.pop();
    });
  }

  Future _onUpdateClick() async {
    setState(() {
      if (_titleController.text.isEmpty) {
        _titleError = "This field cannot be empty";
        return;
      } else {
        _titleError = "";
      }

      if (_brandController.text.isEmpty) {
        _brandError = "This field cannot be empty";
        return;
      } else {
        _brandError = "";
      }

      if (_categoryController.text.isEmpty) {
        _categoryError = "This field cannot be empty";
        return;
      } else {
        _categoryError = "";
      }

      if (_descriptionController.text.isEmpty) {
        _descriptionError = "This field cannot be empty";
        return;
      } else {
        _descriptionError = "";
      }

      final product = Product(title: _titleController.text, brand: _brandController.text, category: _categoryController.text, description: _descriptionController.text, price: double.tryParse(_priceController.text)!, discountPercentage: double.tryParse(_discountController.text)!, rating: double.tryParse(_ratingController.text)!, stock: int.tryParse(_stockController.text)!);
      _updateProduct(product);
      debugPrint("${widget.productId} ${_titleController.text} ${_descriptionController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
        // centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
            padding:EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: TextField(
                  controller: _titleController,
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
                  controller: _brandController,
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
                  controller: _categoryController,
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
                  controller: _descriptionController,
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
                      controller: _priceController,
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
                      controller: _discountController,
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
                      controller: _ratingController,
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
                      controller: _stockController,
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
                      onPressed: () => _onUpdateClick(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text(
                        "Update",
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
