import '../api/auth_api.dart';
import '../models/login/login_model.dart';
import '../models/register/register_model.dart';
import '../models/refresh_token/refresh_token_model.dart';

class AuthRemoteDataSource {
  final AuthApi api;

  AuthRemoteDataSource(this.api);

  Future<LoginModel> login(
    String username,
    String password,
    String loginRole,
    String origin,
  ) {
    return api.login({
      'username': username,
      'password': password,
      'loginRole': loginRole,
      'origin': origin,
    });
  }

  Future<LoginModel> loginWithGoogle(String idToken) {
    return api.loginWithGoogle({'idToken': idToken});
  }

  Future<RegisterModel> register(
    String email,
    String phone,
    String password,
    String role,
  ) {
    return api.register({
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    });
  }

  Future<void> sendRequest(String username) {
    return api.sendRequest({'username': username});
  }

  Future<void> verify(String username, String code, String purpose) {
    return api.verify({'to': username, 'code': code, 'purpose': purpose});
  }

  Future<void> resendCode(String username, String purpose) {
    return api.resendCode({'to': username, 'purpose': purpose});
  }

  Future<void> resetPassword(String username, String newPassword) {
    return api.resetPassword({'username': username, 'password': newPassword});
  }

  Future<RefreshTokenModel> refreshToken(String refreshToken) {
    return api.refreshToken({'refresh_token': refreshToken});
  }
}
