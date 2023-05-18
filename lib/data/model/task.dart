import 'package:flutter/cupertino.dart';

@immutable
class Task {
  static const tableName = "tasks";

  final int id;
  final String title;
  final String description;
  final int priority;
  final int userId;

  const Task({
    this.id = -1,
    required this.title,
    required this.description,
    required this.priority,
    required this.userId
  });

  Task copy({int? id, String? title, String? description, int? priority, int? userId}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId
    );
  }

  @override
  String toString() {
    return "Task($id, $title, $description, $priority, $userId)";
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "priority": priority,
      "fk_user_id": userId
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
        id: map["id"],
        title: map["title"],
        description: map["description"],
        priority: map["priority"] ?? 0,
        userId: map["fk_user_id"] ?? 0
    );
  }
}
