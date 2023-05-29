import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/repository/product_repository_impl.dart';
import 'package:hello_flutter/provider/task_notifier.dart';

import '../data/model/product.dart';

final greetingProvider = Provider((ref) => "Welcome to riverpod 2.0");

final productsRepoProvider = Provider((ref) => ProductRepositoryImpl());

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  return ref.watch(productsRepoProvider).getProducts();
});

final taskStateProvider = StateNotifierProvider<TaskNotifier, MyState>((ref) => TaskNotifier());