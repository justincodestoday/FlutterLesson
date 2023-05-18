import 'package:flutter/cupertino.dart';

@immutable
class Person {
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String title;

  const Person(
      {this.id = -1,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.title});

  Person copy(
      {int? id, String? firstName, String? lastName, int? age, String? title}) {
    return Person(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      title: title ?? this.title,
    );
  }
}
