import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/login/login_model.dart';
import '../models/register/register_model.dart';
import '../models/refresh_token/refresh_token_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login')
  Future<LoginModel> login(@Body() Map<String, dynamic> body);

  @POST('/auth/firebase/callback')
  Future<LoginModel> loginWithGoogle(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<RegisterModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/forgot-password')
  Future<void> sendRequest(@Body() Map<String, dynamic> body);

  @POST('/auth/verify-otp')
  Future<void> verify(@Body() Map<String, dynamic> body);

  @POST('/auth/request-otp')
  Future<void> resendCode(@Body() Map<String, dynamic> body);

  @POST('/auth/reset-password')
  Future<void> resetPassword(@Body() Map<String, dynamic> body);

  @POST('/auth/refresh')
  Future<RefreshTokenModel> refreshToken(@Body() Map<String, dynamic> body);
}
