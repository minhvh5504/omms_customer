import '../../domain/entities/login.dart';
import '../../domain/entities/refresh_token.dart';
import '../../domain/entities/register.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Login> login(
    String username,
    String password,
    String loginRole,
    String origin,
  ) {
    return remoteDataSource.login(username, password, loginRole, origin);
  }

  @override
  Future<Login> loginWithGoogle(String idToken) {
    return remoteDataSource.loginWithGoogle(idToken);
  }

  @override
  Future<Register> register(
    String email,
    String phone,
    String password,
    String role,
  ) async {
    return remoteDataSource.register(email, phone, password, role);
  }

  @override
  Future<void> sendRequest(String username) {
    return remoteDataSource.sendRequest(username);
  }

  @override
  Future<void> verify(String username, String code, String purpose) {
    return remoteDataSource.verify(username, code, purpose);
  }

  @override
  Future<void> resendCode(String username, String purpose) {
    return remoteDataSource.resendCode(username, purpose);
  }

  @override
  Future<void> resetPassword(String username, String newPassword) {
    return remoteDataSource.resetPassword(username, newPassword);
  }

  @override
  Future<RefreshToken> refreshToken(String refreshToken) {
    return remoteDataSource.refreshToken(refreshToken);
  }
}
