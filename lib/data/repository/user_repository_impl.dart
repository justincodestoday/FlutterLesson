import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/data/database/db.dart';

import '../model/user.dart' as user_model;

class UserRepositoryImpl {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection("users");

  Future<int> insertUser(user_model.User user) async {
    return await TaskDatabase.createUser(user);
  }

  Future<List<user_model.User>> getUsers() async {
    final res = await TaskDatabase.getUsers();
    return res.map((e) => user_model.User.fromMap(e)).toList();
  }

  Future<user_model.User?> getUserByEmail(String email) async {
    final res = await TaskDatabase.getUserByEmail(email);
    if (res.isEmpty) {
      return null;
    }
    List<int> image = Uint8List.fromList(res[0]["image"].toList());
    var user = Map.of(res.single);
    user["image"]= image;
    return user_model.User.fromMap(user);
    // return User.fromMap(res.single);
    // return User.fromMap(res[0]);
  }

  Future updateProfilePic(int userId, Uint8List image) async {
    TaskDatabase.updateProfilePic(userId, image);
  }

  Future<void> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> register(user_model.User user) async {
    try {
      final list = await firebaseAuth.fetchSignInMethodsForEmail(user.email);

      // if (list.isEmpty) {
      //   // Return true because there is an existing
      //   // user using the email address
      //   _showSnackbar("Email in use", Colors.red);
      // }
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
      final _user = userCredential.user;
      final hashedPassword = md5.convert(utf8.encode(user.password)).toString();
      await collection.doc(_user?.uid).set({
        'name': user.name,
        'email': user.email,
        'password': hashedPassword,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Re-authenticate the user with the credential
        final userCred = await user.reauthenticateWithCredential(credential);

        // Update the password
        await userCred.user?.updatePassword(newPassword);
        // await user.updatePassword(newPassword);

        debugPrint('Password updated successfully');
      } catch (e) {
        debugPrint('Error updating password: $e');
        // Handle the error accordingly
      }
    }
  }
}