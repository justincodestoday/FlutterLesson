import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/provider/provider.dart';

class Products extends ConsumerWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Products"),
      ),
      body: Center(
        child: Column(
          children: [
            // if note extending ConsumerWidget
            // Consumer(
            //   builder: (_, ref, __) {
            //     final products = ref.watch(productsProvider);
            //     return Container();
            //   },
            // ),

            Text(greeting),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: products.when(
                loading: () => const Center(
                    child: CircularProgressIndicator()
                ),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (items) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(items[index].title),
                          const SizedBox(height: 16),
                          Text(items[index].category)
                        ],
                      )
                    ),
                  ),
                )
              )
            ),
            ElevatedButton(
              onPressed: () => ref.refresh(productsProvider),
              child: const Text("Refresh"),
            )
          ],
        )
      ),
    );
  }
}
