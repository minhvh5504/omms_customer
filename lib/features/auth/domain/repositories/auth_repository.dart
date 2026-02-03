import '../entities/login.dart';
import '../entities/refresh_token.dart';
import '../entities/register.dart';

abstract class AuthRepository {
  Future<Login> login(
    String username,
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
  Future<void> sendRequest(String username);
  Future<void> verify(String username, String code, String purpose);
  Future<void> resendCode(String username, String purpose);
  Future<void> resetPassword(String username, String newPassword);
  Future<RefreshToken> refreshToken(String refreshToken);
}
