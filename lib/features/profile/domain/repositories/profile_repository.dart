import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getUser();
  // Future<Base> updateUser...
}
