import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    required super.uuid,
    super.picture,
    required super.fullName,
    super.email,
    required super.phone,
    super.birthDay,
    required super.role,
    super.money,
    super.gender,
    super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final profilesJson = data['profiles'];

    DateTime? parsedBirth;
    final rawBirth = profilesJson?['birth_date'];
    if (rawBirth is String && rawBirth.isNotEmpty) {
      parsedBirth = DateTime.tryParse(rawBirth);
    }

    return UserModel(
      id: data['id']?.toString(),
      uuid: data['uuid'] ?? '',
      picture: profilesJson?['picture'],
      fullName: profilesJson?['full_name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      birthDay: parsedBirth,
      role: 'user',
      money: (profilesJson?['money'] != null)
          ? double.tryParse(profilesJson['money'].toString())
          : null,
      gender: profilesJson?['gender'],
      address: profilesJson?['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'phone': phone,
      'profiles': {
        'full_name': fullName,
        'birth_date': birthDay?.toIso8601String(),
        'gender': gender,
        'address': address,
      },
      'role': role,
    };
  }
}
