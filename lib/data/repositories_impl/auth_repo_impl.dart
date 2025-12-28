import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/local/auth_local_ds.dart';
import '../datasources/remote/auth_remote_ds.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<User> login(String email, String password) async {
    final json = await remote.login(email, password);
    final user = UserModel.fromJson(json);

    await local.saveUser(user.id, user.email);
    return user;
  }

  @override
  Future<User?> getCurrentUser() async {
    final data = await local.getUser();
    if (data == null) return null;
    return User(id: data['id']!, email: data['email']!);
  }

  @override
  Future<void> logout() async {
    await local.clear();
  }
}

