import '../../../domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    super.fullName,
    super.phone,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map ? json['data'] : json;

    final user = raw['user'] is Map ? raw['user'] : {};

    return LoginModel(
      accessToken: raw['access_token']?.toString() ?? '',
      refreshToken: raw['refresh_token']?.toString() ?? '',
      tokenType: raw['token_type']?.toString() ?? '',
      expiresIn: raw['expires_in']?.toString() ?? '',

      fullName: user['fullName']?.toString(),
      phone: user['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'user': {'fullName': fullName, 'phone': phone},
  };
}
