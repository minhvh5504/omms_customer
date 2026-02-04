import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUser {
  final ProfileRepository repository;

  GetUser(this.repository);

  Future<User> call() async {
    return repository.getUser();
  }
}
