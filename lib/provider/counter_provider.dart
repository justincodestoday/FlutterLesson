import 'package:flutter/cupertino.dart';

class CounterProvider extends ChangeNotifier {
  var count = 0;

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }
}