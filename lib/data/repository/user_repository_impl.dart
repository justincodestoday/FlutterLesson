import 'dart:typed_data';

import 'package:hello_flutter/data/database/db.dart';

import '../model/user.dart';

class UserRepositoryImpl {
  Future<int> insertUser(User user) async {
    return await TaskDatabase.createUser(user);
  }

  Future<List<User>> getUsers() async {
    final res = await TaskDatabase.getUsers();
    return res.map((e) => User.fromMap(e)).toList();
  }

  Future<User?> getUserByEmail(String email) async {
    final res = await TaskDatabase.getUserByEmail(email);
    if (res.isEmpty) {
      return null;
    }
    List<int> image = Uint8List.fromList(res[0]["image"].toList());
    var user = Map.of(res.single);
    user["image"]= image;
    return User.fromMap(user);
    // return User.fromMap(res.single);
    // return User.fromMap(res[0]);
  }

  Future updateProfilePic(int userId, Uint8List image) async {
    TaskDatabase.updateProfilePic(userId, image);
  }
}