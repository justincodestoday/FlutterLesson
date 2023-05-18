import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/data/model/task.dart';
import 'package:hello_flutter/data/repository/task_repository_impl.dart';

import '../service/auth_service.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  var _title = "";
  var _titleError = "";

  var _description = "";
  var _descriptionError = "";

  var _priority = 0;

  final repo = TaskRepositoryImpl();

  final user = AuthService.getUser();

  _onTitleChanged(value) {
    setState(() {
      _title = value;
    });
  }

  _onDescriptionChanged(value) {
    setState(() {
      _description = value;
    });
  }

  _onPriorityChanged(value) {
    setState(() {
      _priority = value;
    });
  }

  Future _createTask(Task task) async {
    await repo.createTask(task);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Future _onCreateClick() async {
    final user = await AuthService.getUser();

    setState(() {
      if (_title.isEmpty) {
        _titleError = "This field cannot be empty";
        return;
      } else {
        _titleError = "";
      }

      if (_description.isEmpty) {
        _descriptionError = "This field cannot be empty";
        return;
      } else {
        _descriptionError = "";
      }

      if (user != null) {
        final task = Task(title: _title, description: _description, priority: _priority, userId: user.id!);
        _createTask(task);
      }
      debugPrint("$_title $_description $_priority");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text("Create Task"),
          // centerTitle: false,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 200,
              color: Colors.grey.shade500,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                onChanged: (value) => {_onTitleChanged(value)},
                decoration: InputDecoration(
                    hintText: "Title",
                    errorText: _titleError.isEmpty ? null : _titleError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: TextField(
                onChanged: (value) => {_onDescriptionChanged(value)},
                decoration: InputDecoration(
                    hintText: "Description",
                    errorText: _descriptionError.isEmpty ? null : _descriptionError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: TextField(
                  onChanged: (value) => { _onPriorityChanged(int.tryParse(value)) },
                  decoration: InputDecoration(
                      labelText: "Enter your number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              )
            ),
            Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: ElevatedButton(
                    onPressed: () => _onCreateClick(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(fontSize: 24),
                    )
                )
            ),
          ]
      ),
    );
  }
}
