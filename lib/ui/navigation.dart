import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/ui/canvas.dart';
import 'package:hello_flutter/ui/persons.dart';
import 'package:hello_flutter/ui/pizza.dart';
import 'package:hello_flutter/ui/product_form.dart';
import 'package:hello_flutter/ui/products.dart';
import 'package:hello_flutter/ui/register.dart';
import 'package:hello_flutter/ui/task_form.dart';
import 'package:hello_flutter/ui/update_form.dart';
import 'package:path/path.dart';

import 'counter.dart';
import 'home_tabs/home.dart';
import 'lake.dart';
import 'login.dart';

class NavigationRoutes extends StatelessWidget {
  final String initialRoute;

  NavigationRoutes({Key? key, required this.initialRoute}) : super(key: key);

  final _routes = [
    GoRoute(
        path: "/login",
        builder: (context, state) => const Login()),
    GoRoute(
        path: "/register",
        builder: (context, state) => const Register()),
    GoRoute(
          path: "/home",
          builder: (context, state) => const Home()),
    // GoRoute(
    //     path: "/home/:email",
    //     name: "home",
    //     builder: (context, state) => Home(
    //       email: state.pathParameters["email"] ?? "",
    //     )
    // ),
    GoRoute(
        path: "/lake",
        builder: (context, state) => const Lake()),
    GoRoute(
        path: "/counter",
        builder: (context, state) => const Counter()),
    GoRoute(
        path: "/persons",
        builder: (context, state) => const Persons()),
    GoRoute(
        path: "/pizza",
        builder: (context, state) => const Pizza()),
    GoRoute(
        path: "/tasks/form",
        builder: (context, state) => const TaskForm()),
    GoRoute(
        path: "/products/form",
        builder: (context, state) => const ProductForm()),
    GoRoute(
        path: "/products/form/update/:id",
        name: "update",
        builder: (context, state) =>
            UpdateForm(productId: state.pathParameters['id'] ?? "")
    ),
    GoRoute(
        path: "/canvas",
        builder: (context, state) => const CustomCanvas()
    ),
    GoRoute(
      path: "/products",
      builder: (context, state) => const Products()
    )
  ];

  // final _router = GoRouter(routes: [
  //   GoRoute(path: "/", builder: (context, state) => const Login()),
  //   GoRoute(
  //       path: "/home/:email",
  //       name: "home",
  //       builder: (context, state) => Home(
  //             email: state.pathParameters["email"] ?? "",
  //           )),
  //   GoRoute(
  //       path: "/lake",
  //       name: "lake",
  //       builder: (context, state) => const Lake()),
  //   GoRoute(
  //       path: "/persons",
  //       name: "Persons",
  //       builder: (context, state) => const Persons()),
  //   GoRoute(
  //       path: "/pizza",
  //       name: "pizza",
  //       builder: (context, state) => const Pizza())
  // ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: initialRoute,
          routes: _routes
        ),
      ),
    );
  }
}
