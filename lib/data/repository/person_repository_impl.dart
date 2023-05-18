import 'package:hello_flutter/data/model/person.dart';
import 'package:hello_flutter/data/repository/person_repository.dart';

class PersonRepositoryImpl extends PersonRepository {
  var counter = 2;
  final _persons = {
    1: const Person(
        id: 1, firstName: 'abc', lastName: 'def', age: 15, title: 'Student'),
    2: const Person(
        id: 2, firstName: 'abc', lastName: 'def', age: 15, title: 'Student'),
  };

  // Singleton instance
  static final PersonRepositoryImpl _instance = PersonRepositoryImpl._internal();

  // Factory method to get the singleton instance
  factory PersonRepositoryImpl() {
    return _instance;
  }

  // PersonRepositoryImpl._(); // same as
  PersonRepositoryImpl._internal();

  @override
  List<Person> getPersons() {
    return _persons.entries.map((e) => e.value).toList();
  }

  @override
  bool addPerson(Person person) {
    _persons[++counter] = person.copy(id: counter);
    return true;
  }

  @override
  bool deletePerson(int id) {
    return _persons.remove(id) != null;
  }
}
