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

class _ThirdTabState extends State<ThirdTab> {
  final repo = UserRepositoryImpl();
  File? image;
  String base64ImageString = "";
  User? user;
  int? userId;
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    fetchUser();
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
          )
          // Text(email),
        ],
      ),
    );
  }
}
