import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

sealed class AuthRemoteDataSource {
  Future<UserModel> login(LoginModel model);
  Future<void> logout();
  Future<void> register(RegisterModel model);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // In-memory static database of users to simulate persistent backend data across requests
  static final Map<String, UserModel> _mockUsers = {
    "admin@gmail.com": const UserModel(
      userId: "admin_id",
      email: "admin@gmail.com",
      username: "admin",
      password: "password123",
    ),
  };

  @override
  Future<UserModel> login(LoginModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final email = model.email ?? "";
      final password = model.password ?? "";

      // If the user doesn't exist, we auto-register them with the entered password!
      // This guarantees users can always bypass any login bottlenecks.
      if (!_mockUsers.containsKey(email)) {
        _mockUsers[email] = UserModel(
          userId: "dummy_${DateTime.now().millisecondsSinceEpoch}",
          email: email,
          username: email.split('@')[0],
          password: password,
        );
      }

      final user = _mockUsers[email]!;
      if (user.password != password) {
        throw AuthException();
      }

      return user;
    } catch (e) {
      logger.e(e);
      throw AuthException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> register(RegisterModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final email = model.email ?? "";
      if (_mockUsers.containsKey(email)) {
        throw DuplicateEmailException();
      }

      _mockUsers[email] = UserModel(
        userId: "dummy_${DateTime.now().millisecondsSinceEpoch}",
        email: email,
        username: model.username ?? email.split('@')[0],
        password: model.password ?? "",
      );
      return;
    } on DuplicateEmailException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }
}
