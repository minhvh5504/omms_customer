import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;
  ResetPassword(this.repository);

  Future<void> call(String username, String newPassword) {
    return repository.resetPassword(username, newPassword);
  }
}
