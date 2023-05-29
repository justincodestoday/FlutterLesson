import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/data/repository/product_repository_impl.dart';
import 'package:hello_flutter/ui/product_form.dart';
import 'package:provider/provider.dart';

import '../../data/model/product.dart';
import '../../provider/product_provider.dart';

class SecondTab extends StatefulWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  State<SecondTab> createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  final repo = ProductRepositoryImpl();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> _refreshData() async {
    // Perform your data fetching or refreshing logic here
    // For example, fetch updated product data from an API
    List<Product> refreshedProducts = await getProducts();

    setState(() {
      products = refreshedProducts;
      debugPrint(products.toString());
    });
  }

  Future _createProduct() async {
    final product = Product(title: "Winnie the Pooh", brand: '', category: 'Plushie', description: '', price: 100.0, discountPercentage: 0.0, rating: 5.0, stock: 2, );
    await repo.insertItem(product).then((_) =>
        setState(() {
          getProducts();
        })
    );
  }

  void _toCreate() async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ProductForm()),
    // );

    await context.push("/products/form");

    setState(() {
      getProducts();
      // Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
  }

  Future getProducts() async {
    final fetchedProducts = await repo.getProducts();
    setState(() {
      products = fetchedProducts;
    });
  }

  Future _deleteProduct(String id) async {
    await repo.deleteItem(id);
    setState(() {
      getProducts();
    });
  }

  Future _updateProduct(Product product) async {
    final updatedProduct = Product(id: product.id, title: "Updated product", brand: '', category: '', description: '', price: 0, discountPercentage: 0, rating: 0, stock: 0);
    await repo.updateItem(product.id!, updatedProduct).then((_) =>
      setState(() {
          getProducts();
        }
      )
    );
  }

  void _toUpdate(String id) async {
    await context.pushNamed("update", pathParameters: {'id': id});

    setState(() {
      getProducts();
      // Provider.of<ProductProvider>(context, listen: false).getProducts();
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
                    onPressed: () { Navigator.of(context).pop(true); },
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
      _toUpdate(product.id!);
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
        // onRefresh: () async {
        //   Provider.of<ProductProvider>(context, listen: false).getProducts();
        // },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red.shade200,
                // width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child:
                // child: Consumer<ProductProvider>(
                //   builder: (context, productProvider, _) =>
                ListView.builder(
                    itemCount: products.length,
                    // itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      debugPrint(products.length.toString());
                      final product = products[index];
                      // final product = productProvider.products[index];
                      final title = product.title;
                      final description = product.description;
                      final category = product.category;
                      final price = product.price;

                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Dismissible(
                          key: Key(product.id.toString()),
                          onDismissed: (dir) { _deleteProduct(product.id!); },
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
                                        _toUpdate(product.id!);
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
        onPressed: () => _toCreate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
