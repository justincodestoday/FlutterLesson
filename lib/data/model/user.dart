import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  // final String? image;
  final Uint8List? image;

  static const String tableName = "users";

  User({this.id, required this.name, required this.email, required this.password, this.image});

  Map<String, dynamic> toMap() {
    final String hashedPassword = md5.convert(utf8.encode(password)).toString();
    return {
      "name": name,
      "email": email,
      "password": hashedPassword,
      "image": image
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        password: map["password"],
        image: map["image"]
    );
  }
}
