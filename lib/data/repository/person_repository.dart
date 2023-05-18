import '../model/person.dart';

abstract class PersonRepository {
  List<Person> getPersons();
  bool addPerson(Person person);
  bool deletePerson(int id);
}