import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/service/auth_service.dart';

import '../data/model/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _email = "";
  var _emailError = "";

  var _password = "";
  var _passwordError = "";

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

  _onLoginClick() {
    setState(() {
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

      // if (_email == "abc@abc.com" && _password == "qweqweqwe" ||
      //     _email == "abc@abc2.com" && _password == "qweqweqwe") {
      //   // GoRouter.of(context).pushNamed("home", pathParameters: {"email": _email});
      //   context.pushNamed("home", pathParameters: {'email': _email});
      //   // context.go("/home");
      //   AuthService.authenticate(
      //       User(id: 0, name: _name, email: _email, password: _password));
      // }

      AuthService.authenticate(
          _email, _password, (status) => {
            if (status) {
              context.push("/home")
              // context.pushNamed("home", pathParameters: {'email': _email})
            } else {
              debugPrint("Wrong Credentials")
            }
          }
      );

      debugPrint("$_email $_password");
    });
  }

  _toRegister() {
    context.push("/register");
  }

  _onToLake() {
    context.push("/lake");
  }

  _onNavigateToPersons(BuildContext context) async {
    var action = await context.push("/persons");
    debugPrint(action as String);
  }

  // _onNavigateToPersons() {
  //   context.push("/persons");
  // }

  _onToPizza() {
    context.push("/pizza");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.yellow,
      appBar: AppBar(
          title: const Text("Login"),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () => debugPrint("Hello Scaffold email"),
                icon: const Icon(Icons.mail)),
            IconButton(
                onPressed: () => debugPrint("Hello Scaffold sms"),
                icon: const Icon(Icons.sms))
          ]),
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
                onChanged: (value) => {_onEmailChanged(value)},
                decoration: InputDecoration(
                    hintText: "Email",
                    errorText: _emailError.isEmpty ? null : _emailError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            // Password(onPassChanged: _onPasswordChanged(_password), passError: _passwordError),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
                    onPressed: () => _onLoginClick(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 24),
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: ElevatedButton(
                    onPressed: () => _toRegister(),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.grey,
                        minimumSize: const Size.fromHeight(40)),
                    child: const Text(
                      "Create an account",
                      style: TextStyle(fontSize: 24),
                    )
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                      onPressed: () => _onToLake(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.orange, //<-- SEE HERE
                      ),
                      child: const Text("Camp")),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                      onPressed: () => _onNavigateToPersons(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.purple, //<-- SEE HERE
                      ),
                      child: const Text("Navigate To Persons")),
                ),
                ElevatedButton(
                    onPressed: () => _onToPizza(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.orange, //<-- SEE HERE
                    ),
                    child: const Text("Pizza"))
          ],
        )
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {}, child: const Icon(Icons.add)),
    );
  }
}

class Password extends StatelessWidget {
  final Function onPassChanged;
  final String passError;

  const Password({Key? key, required this.onPassChanged, required this.passError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      child: TextField(
        onChanged: (value) => { onPassChanged(value)},
        decoration: InputDecoration(
            hintText: "Password",
            errorText: passError.isEmpty ? null : passError,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0))),
        obscureText: true,
      ),
    );
  }
}


/*
  Row, Column, Text, TextField, ElevatedButton,
  FloatingActionButton, Scaffold, AppBar,
  After the class, I want all of you to explore these topics,
  try to design a register page with validation

 */
