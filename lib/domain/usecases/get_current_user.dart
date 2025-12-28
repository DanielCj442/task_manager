import '../entities/user.dart';
import '../repositories/auth_repo.dart';


class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<User?> call() {
    return repository.getCurrentUser();
  }
}
