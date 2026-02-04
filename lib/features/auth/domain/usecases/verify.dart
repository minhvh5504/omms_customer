import '../repositories/auth_repository.dart';

class Verify {
  final AuthRepository repository;
  Verify(this.repository);

  Future<void> call(String phone, String code, String purpose) {
    return repository.verify(phone, code, purpose);
  }
}
