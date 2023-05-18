import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/person.dart';

class Persons extends StatefulWidget {
  const Persons({Key? key}) : super(key: key);

  @override
  State<Persons> createState() => _PersonsState();
}

class _PersonsState extends State<Persons> {
  final _persons = [
    const Person(
        firstName: "Peter", lastName: "Parker", age: 20, title: "Spider-Man"),
    const Person(
        firstName: "Tony", lastName: "Stark", age: 55, title: "Iron Man"),
    const Person(
        firstName: "Bruce", lastName: "Banner", age: 56, title: "Hulk"),
  ];

  _onClickBack() {
    context.pop("Hello from persons. Back");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Persons"),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: Colors.lightBlue,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: _persons.length,
                      itemBuilder: (context, index) {
                        final person = _persons[index];
                        final firstName = person.firstName;
                        final lastName = person.lastName;
                        final age = person.age;
                        final title = person.title;

                        return Column(children: [
                          Text("$firstName $lastName"),
                          Text("Age: $age"),
                          Text("Title: $title"),
                          const SizedBox(
                            height: 20,
                          )
                        ]);
                      }))),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ElevatedButton(
                onPressed: () => _onClickBack(), child: const Text("Back") // this calls the function that executes the function onClickBack
                // onPressed: _onClickBack, child: const Text("Back") // this calls the onClickBack function
            ),
          )
        ],
      ),
    );
  }
}

// RiverPod or Bloc
