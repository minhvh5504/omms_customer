class User {
  final String? id;
  final String uuid;
  final String? picture;
  final String fullName;
  final String? email;
  final String phone;
  final DateTime? birthDay;
  final String role;
  final double? money;
  final String? gender;
  final String? address;

  const User({
    this.id,
    required this.uuid,
    this.picture,
    required this.fullName,
    this.email,
    required this.phone,
    this.birthDay,
    required this.role,
    this.money,
    this.gender,
    this.address,
  });
}
