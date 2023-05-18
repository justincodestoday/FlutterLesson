import '../model/task.dart';

abstract class TaskRepository {
  Future<List<Task>?> getTasks();
  Future<List<Task>?> getTasksByUserId(int userId);
  Future<Task?> getTask(int id);
  Future<bool> createTask(Task task);
  Future<bool> updateTask(Task task);
  Future<bool> deleteTask(int id);
}