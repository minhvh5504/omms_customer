import '../entities/login.dart';
import '../entities/refresh_token.dart';
import '../entities/register.dart';

abstract class AuthRepository {
  Future<Login> login(
    String phone,
    String password,
    String loginRole,
    String origin,
  );
  Future<Login> loginWithGoogle(String idToken);
  Future<Register> register(
    String email,
    String phone,
    String password,
    String role,
  );
  Future<void> sendRequest(String phone);
  Future<void> verify(String phone, String code, String purpose);
  Future<void> resendCode(String phone, String purpose);
  Future<void> resetPassword(String phone, String newPassword);
  Future<RefreshToken> refreshToken(String refreshToken);
}
