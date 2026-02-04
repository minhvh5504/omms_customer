import '../models/user_model.dart';

class ProfileRemoteDataSource {
  // final ProfileApi api;

  ProfileRemoteDataSource();

  Future<UserModel> getUser() async {
    // Fake implementation
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    return UserModel(
      id: '1',
      uuid: 'fake-uuid-123',
      fullName: 'Nguyen Van A',
      email: 'a@example.com',
      phone: '0901234567',
      role: 'user',
      gender: 'Male',
      address: 'Hanoi, Vietnam',
      birthDay: DateTime.now(),
      money: 1000000.0,
      picture: 'https://via.placeholder.com/150',
    );
  }

  // Future<BaseModel> updateUser... // Commented out
}
