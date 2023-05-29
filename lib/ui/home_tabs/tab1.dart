import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/data/model/task.dart';
import 'package:hello_flutter/data/model/user.dart';
import 'package:hello_flutter/data/repository/person_repository_impl.dart';
import 'package:hello_flutter/provider/provider.dart';
import 'package:hello_flutter/service/auth_service.dart';
import 'package:hello_flutter/ui/task_form.dart';

import '../../data/model/person.dart';
import '../../data/repository/task_repository_impl.dart';

class FirstTab extends StatefulWidget {
  // final PersonRepositoryImpl repo;
  // final TaskRepositoryImpl repo;

  const FirstTab({Key? key}) : super(key: key);

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  // List<Person> _persons = []; // or
  // var _persons = <Person>[];
  var _tasks = <Task>[];

  // final repo = PersonRepositoryImpl();
  // PersonRepositoryImpl repo = PersonRepositoryImpl();
  TaskRepositoryImpl repo = TaskRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final user = await AuthService.getUser();
    if (user != null) {
      final res = await repo.getTasksByUserId(user.id!);

      // do not use asynchronous programming in setState(),
      // setState() should be fast
      setState(() {
        // _persons = repo.getPersons();
        _tasks = res ?? [];
      });
    }
  }

  // void addPerson() {
  //   setState(() {
  //     var person = const Person(
  //         firstName: "Peter",
  //         lastName: "Parker",
  //         age: 21,
  //         title: "Student");
  //     repo.addPerson(person);
  //     refresh();
  //   });
  // }

  void _createTask() async {
    final user = await AuthService.getUser();
    if (user != null) {
      final task = Task(title: "Urgent", description: "Wash the dishes", priority: 3, userId: user.id!);
      await repo.createTask(task);
      _refresh();
    }
  }

  void _deleteTask(int id) async {
    await repo.deleteTask(id);
    _refresh();
  }

  void _updateTask(Task task) async {
    final user = await AuthService.getUser();
    final newTask = Task(id: task.id, title: "Updated task", description: "Updated description", priority: 4, userId: user?.id ?? -1);
    await repo.updateTask(newTask);
    _refresh();
  }

  void _toCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskForm()),
    );

    setState(() {
      _refresh();
    });
  }

  Future<bool> _onConfirmDismiss(DismissDirection dir, Task task) async {
    if(dir == DismissDirection.endToStart) {
      return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("This item will be deleted and this action cannot be undone."),
              actions: [
                ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(true); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    child: const Text("YES")
                ),
                ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(false); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("NO")
                )
              ],
            );
          }
      );
    } else if (dir == DismissDirection.startToEnd) {
      _updateTask(task);
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Consumer(
          builder: (_, WidgetRef ref, __) {
            final myState = ref.watch(taskStateProvider);
            return Column(
              children: [
                Text(
                  myState.counter.toString(),
                  style: const TextStyle(fontSize: 22),
                ),
                ElevatedButton(
                    onPressed: () {
                      ref.read(taskStateProvider.notifier).increment();
                    },
                    child: const Text("Increment")
                )
              ]
            );
          },
        ),
        Expanded(
            child: Container(
                color: Colors.green,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    debugPrint(_tasks.length.toString());
                    // final person = _persons[index];
                    final task = _tasks[index];
                    final title = task.title;
                    final description = task.description;
                    final priority = task.priority;

                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Dismissible(
                        key: Key(task.id.toString()),
                        onDismissed: (dir) { _deleteTask(task.id); },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(margin: const EdgeInsets.only(left: 16) , alignment: Alignment.centerLeft,child: const Text("Update"),),
                        ),
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Container(margin: const EdgeInsets.only(right: 16) , alignment: Alignment.centerRight,child: const Text("Delete"),),
                        ),
                        confirmDismiss: (dir) async {
                          // if (dir == DismissDirection.endToStart) {
                          //   return true;
                          // }
                          // _updateTask(task);
                          // return false;
                          return _onConfirmDismiss(dir, task);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("$title ${task.id}"),
                                      Text(description),
                                      Text("Priority: $priority")
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _updateTask(task);
                                    },
                                    child: const Icon(Icons.edit),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     _deleteTask(_tasks[index].id);
                                  //   },
                                  //   child: const Icon(Icons.delete),
                                  // )
                                ],
                              ),
                              // Text(_persons[index].firstName),
                              // const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
            )
        ),
        // Expanded(
        //     flex: 1,
        //     child: Container(
        //       color: Colors.red,
        //       width: double.infinity,
        //       child: const Text("Expanded Widget"),
        //     ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toCreate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Hello Flutter",
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 20.5, color: Colors.blue),
    );
  }
}
