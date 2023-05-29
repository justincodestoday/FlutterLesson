import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/task.dart';

class MyState {
  MyState({required this.tasks, required this.counter});
  var tasks = <Task>[];
  var counter = 0;
}

class TaskNotifier extends StateNotifier<MyState> {
  TaskNotifier() : super(MyState(tasks: [], counter: 0));

  void increment() {
    // state = state..counter = state.counter + 1;
    state = MyState(tasks: state.tasks, counter: state.counter + 1);
  }
}