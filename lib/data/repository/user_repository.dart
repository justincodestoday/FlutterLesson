import '../model/user.dart';

abstract class UserRepository {
  Future<void> login(String email, String password);
  Future<void> register(User user);
}