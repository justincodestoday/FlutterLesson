import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/service/auth_service.dart';
import 'package:hello_flutter/ui/home_tabs/tab1.dart';
import 'package:hello_flutter/ui/home_tabs/tab2.dart';
import 'package:hello_flutter/ui/home_tabs/tab3.dart';
import 'package:hello_flutter/ui/home_tabs/tab4.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/user.dart';
import '../../data/repository/user_repository_impl.dart';

class Home extends StatefulWidget {
  // final String email;

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // final repo = PersonRepositoryImpl();
  // final repo = TaskRepositoryImpl();

  // var _user = User(name: '', email: ''); // or
  final repo = UserRepositoryImpl();
  User? user;
  late final _tabController = TabController(length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Widget _tabItem(String str, IconData icon) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(str)
        ],
      ),
    );
  }

  Future _getUser() async {
    final user = await AuthService.getUser();
    if (user != null) {
      final temp = await repo.getUserByEmail(user.email);
      debugPrint(temp?.image.toString());
      setState(() {
        this.user = temp;
      });
    }
  }

  void _navigateToScene(BuildContext context) {
    context.push("/lake");
  }

  void _navigateToCounter(BuildContext context) {
    context.pop();
    context.push("/counter");
  }

  void _logout(BuildContext context) {
    AuthService.deauthenticate();
    context.pop();
    context.go("/login");
  }

  void _navigateToAccount(BuildContext context) {
    context.push("/persons");
  }

  void _toTab(BuildContext context) {
    _tabController.index = 2;
    Navigator.of(context).pop();
  }

  // Uint8List getImageBytes() {
  //   return base64Decode(_user?.image ?? "");
  // }

  void _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      final bytes = imageFile.readAsBytesSync();

      setState(() {
        if (user != null) {
          repo.updateProfilePic(user!.id!, bytes);
          _getUser();
        }
      });
    }
  }

  // in conventional kotlin, view holds the content
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          // bottom: TabBar(
          //     indicator: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50), // Creates border
          //         color: Colors.lightBlueAccent), //C
          //     tabs: const [
          //       Tab(icon: Icon(Icons.home)),
          //       Tab(icon: Icon(Icons.settings)),
          //       Tab(icon: Icon(Icons.person)),
          // ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            FirstTab(),
            SecondTab(),
            ThirdTab(),
            FourthTab()
        ],),
        bottomNavigationBar: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Colors.lightBlueAccent), //C
            tabs: [
              _tabItem("Home", Icons.home),
              _tabItem("Settings", Icons.settings),
              _tabItem("Profile", Icons.person),
              _tabItem("Shop", Icons.shop),
            ]
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
              padding: EdgeInsets.zero,
              children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue.shade200),
                child: Column(
                  children: [
                    // Text("Hello ${_user.name}"),
                    GestureDetector(
                      onTap: () { _toTab(context); },
                      child: user?.image != null ? SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.memory(user!.image!)) : const Icon(Icons.person, size: 80)
                    ),
                    Container(
                      child: ElevatedButton(
                          onPressed: () => _pickImage(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size.fromHeight(20),
                          ),
                          child: const Text("Pick Image")
                      ),
                    ),
                  ]
                ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                          onTap: () => { _navigateToScene(context) },
                          title: const Text("Lake",
                              style: TextStyle(
                                  color: Colors.indigo, fontSize: 18))),
                      ListTile(
                          onTap: () => { _navigateToCounter(context) },
                          title: const Text("Counter",
                              style: TextStyle(
                                  color: Colors.indigo, fontSize: 18))),
                      ListTile(
                          onTap: () { _logout(context); },
                          title: const Text("Logout",
                              style: TextStyle(
                                  color: Colors.indigo, fontSize: 18)))
                    ]
                )
            )
          ]),
        ),
      ),
    );
  }
}
// can return Material instead of Container?
