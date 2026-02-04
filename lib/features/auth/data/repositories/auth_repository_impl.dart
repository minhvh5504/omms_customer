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
    String phone,
    String password,
    String loginRole,
    String origin,
  ) {
    return remoteDataSource.login(phone, password, loginRole, origin);
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
  Future<void> sendRequest(String phone) {
    return remoteDataSource.sendRequest(phone);
  }

  @override
  Future<void> verify(String phone, String code, String purpose) {
    return remoteDataSource.verify(phone, code, purpose);
  }

  @override
  Future<void> resendCode(String phone, String purpose) {
    return remoteDataSource.resendCode(phone, purpose);
  }

  @override
  Future<void> resetPassword(String phone, String newPassword) {
    return remoteDataSource.resetPassword(phone, newPassword);
  }

  @override
  Future<RefreshToken> refreshToken(String refreshToken) {
    return remoteDataSource.refreshToken(refreshToken);
  }
}
