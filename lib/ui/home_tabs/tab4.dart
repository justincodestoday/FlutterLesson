import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/product.dart';

class FourthTab extends StatefulWidget {
  const FourthTab({Key? key}) : super(key: key);

  @override
  State<FourthTab> createState() => _FourthTabState();
}

class _FourthTabState extends State<FourthTab> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> _refreshData() async {
    var collection = FirebaseFirestore.instance.collection("products");
    var querySnapshot = await collection.get();
    var productList = querySnapshot.docs
        .map((doc) => Product.fromMap(doc.data()))
        .toList().cast<Product>();
    setState(() {
      products = productList;
    });
  }

  Future createProduct() async {
    var collection = FirebaseFirestore.instance.collection("products");
    var id = collection.doc().id;
    var product = Product(id: id, title: "God of War: Ragnarok", brand: "", category: "Video game", description: "Console game", price: 299, discountPercentage: 0, rating: 5.0, stock: 10);
    // await collection.add(product.toMap());
    collection.doc(id).set(product.toMap());

    setState(() {
      _refreshData();
    });
  }

  Future getProducts() async {
    var collection = FirebaseFirestore.instance.collection("products");

    var querySnapshot = await collection.get();

    for (var item in querySnapshot.docs) {
      var data = item.data();
      debugPrint("${data['title']} ${data['description']}");

      var product = Product.fromMap(data);
      debugPrint(product.toString());
      setState(() {
        products.add(product);
      });
    }
  }

  Future _deleteProduct(String id) async {
    debugPrint(id);
    final collection = FirebaseFirestore.instance.collection("products");
    await collection.doc(id).delete();

    setState(() {
      products.removeWhere((product) => product.id == id);
    });
  }

  Future _updateProduct(String id) async {
    var product = Product(id: id, title: "Legend of Zelda", brand: "", category: "Video game", description: "Console game", price: 299, discountPercentage: 0, rating: 5.0, stock: 10);
    final collection = FirebaseFirestore.instance.collection("products");
    await collection.doc(id).set(product.toMap());

    setState(() {
      _refreshData();
    });
  }

  Future<bool> _onConfirmDismiss(DismissDirection dir, Product product) async {
    if(dir == DismissDirection.endToStart) {
      return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("This item will be deleted and this action cannot be undone."),
              actions: [
                ElevatedButton(
                    onPressed: () async { Navigator.of(context).pop(true); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    child: const Text("YES")
                ),
                ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(false); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("NO")
                )
              ],
            );
          }
      );
    } else if (dir == DismissDirection.startToEnd) {
      _updateProduct(product.id!);
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red.shade200,
                // width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    debugPrint(products.length.toString());
                    final product = products[index];
                    final title = product.title;
                    final description = product.description;
                    final category = product.category;
                    final price = product.price;
                    final id = product.id;

                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Dismissible(
                        key: Key(id!),
                        onDismissed: (dir) { _deleteProduct(id); },
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(margin: const EdgeInsets.only(left: 16) , alignment: Alignment.centerLeft,child: const Text("Update"),),
                        ),
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(margin: const EdgeInsets.only(right: 16) , alignment: Alignment.centerRight,child: const Text("Delete"),),
                        ),
                        confirmDismiss: (dir) async {
                          return _onConfirmDismiss(dir, product);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title),
                                      Text(description),
                                      Text("Category: $category"),
                                      Text("Price: $price")
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _updateProduct(product.id!);
                                    },
                                    child: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
