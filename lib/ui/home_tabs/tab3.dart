import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hello_flutter/data/repository/user_repository_impl.dart';
import 'package:hello_flutter/service/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/user.dart';

class ThirdTab extends StatefulWidget {
  // final String email;

  const ThirdTab({Key? key}) : super(key: key);

  @override
  State<ThirdTab> createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> with SingleTickerProviderStateMixin {
  UserRepositoryImpl userRepo = UserRepositoryImpl();
  final repo = UserRepositoryImpl();
  File? image;
  String base64ImageString = "";
  User? user;
  int? userId;
  Uint8List? bytes;

  late AnimationController controller;
  TextEditingController textController = TextEditingController(text: "initial value");
  var _angle = 0.0;
  var _scale = 0.0;
  var _color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    fetchUser();

    var colorTween = ColorTween(begin: Colors.transparent, end: Colors.blue);
    controller = AnimationController(duration: Duration(seconds: 10), vsync: this);
    textController.text = "override";
    var colorTweenAnimation = colorTween.animate(controller);

    colorTweenAnimation.addListener(() {
      setState(() {
        _color = colorTweenAnimation.value ?? Colors.transparent;
      });
    });

    controller.addListener(() {
      setState(() {
        _angle = 50 * controller.value;
        _scale = 2 * controller.value;
      });
      debugPrint("Value: ${controller.value.toString()}");
    });
  }

  Future fetchUser() async {
    final user = await AuthService.getUser();
    if (user != null) {
      final temp = await repo.getUserByEmail(user.email);
      setState(() {
        this.user = temp;
      });
    }
  }

  // Uint8List getImageBytes() {
  //   return base64Decode(base64ImageString);
  // }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      final bytes = imageFile.readAsBytesSync();
      // final imageString = base64Encode(bytes);
      // debugPrint(imageString);

      setState(() {
        if (user != null) {
          repo.updateProfilePic(user!.id!, bytes);
          fetchUser();
        }
        this.image = imageFile;
        // base64ImageString = imageString;
      });
    }
  }

  _updatePassword() async {
    const password = "newpassword";
    const newPassword = "qweqweqwe";
    await userRepo.updatePassword(password, newPassword);
  }

  void _startAnimation() {
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () => _pickImage(),
              child: const Text("Pick Image")
          ),

          Container(
            // child: user?.image != null ? Image.memory(getImageBytes()) : Container()
            child: image != null ? Image.file(image!) : user?.image != null ? Image.memory(user!.image!): Container(child: const Icon(Icons.person),)
          ),
          // Text(email),

          ElevatedButton(
              onPressed: () => _updatePassword(),
              child: const Text("Update Password")
          ),

          SizedBox(height: 32,),
          Transform.rotate(
            angle: _angle,
            origin: Offset(10.0, 10.0),
            child: const Icon(Icons.settings, size: 64,),
          ),
          SizedBox(height: 32,),
          Transform.scale(
            scale: _scale,
            child: Icon(Icons.settings, color: _color, size: 64)
          ),
          SizedBox(height: 32,),
          Transform(
            transform: Matrix4.rotationX(_angle)..rotateY(_angle),
            child: const Icon(Icons.settings, size: 64,),
          ),
          SizedBox(height: 32,),
          Transform(
            transform: Matrix4.identity()..translate(_angle),
            child: const Icon(Icons.settings, size: 64,),
          ),
          ElevatedButton(
              onPressed: () => _startAnimation(),
              child: const Text("Start animation")
          ),
        ],
      ),
    );
  }
}
