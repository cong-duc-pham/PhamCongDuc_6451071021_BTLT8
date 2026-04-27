import '../models/user.dart';
import '../repository/user_repository.dart';

class AuthService {
  final UserRepository _repo;
  AuthService(this._repo);

  Future<User?> login(String email, String password) {
    return _repo.findByEmailAndPassword(email.trim(), password);
  }

  Future<void> register(String email, String password) {
    return _repo.insertUser(User(email: email.trim(), password: password));
  }
}