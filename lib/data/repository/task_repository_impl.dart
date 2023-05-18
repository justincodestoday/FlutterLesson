import 'package:hello_flutter/data/repository/task_repository.dart';

import '../database/db.dart';
import '../model/task.dart';

class TaskRepositoryImpl extends TaskRepository {
  static final TaskRepositoryImpl _instance = TaskRepositoryImpl._();

  factory TaskRepositoryImpl() {
    return _instance;
  }

  TaskRepositoryImpl._();

  @override
  Future<List<Task>?> getTasks() async {
    final res = await TaskDatabase.getTasks();
    if (res.isEmpty) {
      return null;
    }
    return res.map((e) => Task.fromMap(e)).toList();
  }

  @override
  Future<List<Task>?> getTasksByUserId(int userId) async {
    final res = await TaskDatabase.getTasksByUserId(userId);
    if (res.isEmpty) {
      return null;
    }
    return res.map((e) => Task.fromMap(e)).toList();
  }

  @override
  Future<Task?> getTask(int id) async {
    final res = await TaskDatabase.getTask(id);
    if (res.isEmpty) {
      return null;
    }
    return Task.fromMap(res[0]);
  }

  @override
  Future<bool> createTask(Task task) async {
    await TaskDatabase.createTask(task);
    return true;
  }

  @override
  Future<bool> updateTask(Task task) async {
    await TaskDatabase.updateTask(task);
    return true;
  }

  @override
  Future<bool> deleteTask(int id) async {
    await TaskDatabase.deleteTask(id);
    return true;
  }
}
