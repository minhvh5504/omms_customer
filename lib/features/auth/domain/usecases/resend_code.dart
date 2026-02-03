import '../repositories/auth_repository.dart';

class ResendCode {
  final AuthRepository repository;
  ResendCode(this.repository);

  Future<void> call(String username, String purpose) {
    return repository.resendCode(username, purpose);
  }
}
