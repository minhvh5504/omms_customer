import '../repositories/auth_repository.dart';

class ResendCode {
  final AuthRepository repository;
  ResendCode(this.repository);

  Future<void> call(String phone, String purpose) {
    return repository.resendCode(phone, purpose);
  }
}
