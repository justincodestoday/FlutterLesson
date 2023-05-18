import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/service/auth_service.dart';

import '../data/model/user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _name = "";
  var _nameError = "";

  var _email = "";
  var _emailError = "";

  var _password = "";
  var _passwordError = "";

  _onNameChanged(value) {
    setState(() {
      _name = value;
    });
  }

  _onEmailChanged(value) {
    setState(() {
      _email = value;
    });
  }

  _onPasswordChanged(value) {
    setState(() {
      _password = value;
    });
  }

  _onRegisterClick() {
    setState(() {
      if (_name.isEmpty) {
        _nameError = "This field cannot be empty";
        return;
      } else {
        _nameError = "";
      }

      if (_email.isEmpty) {
        _emailError = "This field cannot be empty";
        return;
      } else {
        _emailError = "";
      }

      if (_password.isEmpty) {
        _passwordError = "This field cannot be empty";
        return;
      } else {
        _passwordError = "";
      }

      AuthService.createUser(
        User(name: _name, email: _email, password: _password)
      );
      context.pop();

      debugPrint("$_name $_email $_password");
    });
  }

  _toLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
          title: const Text("Register"),
          centerTitle: false,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
            child: TextField(
              onChanged: (value) => {_onNameChanged(value)},
              decoration: InputDecoration(
                  hintText: "Name",
                  errorText: _nameError.isEmpty ? null : _nameError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
            child: TextField(
              onChanged: (value) => {_onEmailChanged(value)},
              decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _emailError.isEmpty ? null : _emailError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
            child: TextField(
              onChanged: (value) => {_onPasswordChanged(value)},
              decoration: InputDecoration(
                  hintText: "Password",
                  errorText: _passwordError.isEmpty ? null : _passwordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              obscureText: true,
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                  onPressed: () => _onRegisterClick(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 24),
                  )
              )
          ),
          Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                  onPressed: () => _toLogin(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.grey,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text(
                    "Return to login",
                    style: TextStyle(fontSize: 24),
                  )
              )
          ),
        ],
      ),
    );
  }
}
