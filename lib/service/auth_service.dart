import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hello_flutter/data/database/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user.dart';

class AuthService {
    // use static when only creating one object instead of multiple objects,
    // meaning no duplicates of authenticate function or deauthenticate function

    static SharedPreferences? sharedPref;

    static Future<SharedPreferences> createPref() async {
        if(sharedPref != null) {
            return sharedPref!;
        }
        sharedPref = await SharedPreferences.getInstance();
        return sharedPref!;
    }

    static Future<bool> isLoggedIn() async {
        final user = await getUser();
        return user != null;
    }

    static Future createUser(User user) async {
        TaskDatabase.createUser(user);
    }

    static Future updateUser(User user) async {
        await TaskDatabase.updateUser(user);
    }

    static void authenticate(String email, String password, Function(bool) callback) async {
        final res = await TaskDatabase.getUserByEmail(email);
        if (res.isEmpty) {
            callback(false);
        }

        final User authUser = User.fromMap(res[0]);
        final String hashedPassword = md5.convert(utf8.encode(password)).toString();
        if (authUser.password != hashedPassword) {
            callback(false);
        }

        final sharedPref = await createPref();
        final user = authUser.toMap();
        user["id"] = authUser.id;
        user["image"] = null;

        final userString = jsonEncode(user);
        sharedPref.setString("user", userString);
        callback(true);
    }

    // static Future authenticate(User user) async {
    //     final sharedPref = await createPref();
    //     final userString = jsonEncode(user.toMap());
    //     sharedPref.setString("user", userString);
    // }

    static Future deauthenticate() async {
        final sharedPref = await createPref();
        sharedPref.remove("user");
    }

    static Future<User?> getUser() async {
        final sharedPref = await createPref();
        final userString = sharedPref.getString("user");
        if (userString != null) {
            return User.fromMap(jsonDecode(userString));
        }
        return null;
    }
}