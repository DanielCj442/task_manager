import '../repositories/auth_repo.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
