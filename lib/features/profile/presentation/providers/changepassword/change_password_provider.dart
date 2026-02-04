// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../../core/network/api_client.dart';
// import '../../../data/api/profile_api.dart';
// import '../../../data/datasources/profile_remote_datasource.dart';
// import '../../../data/repositories/profile_repository_impl.dart';
// import '../../../domain/usecases/change_password.dart';
// import 'change_password_notifier.dart';

// /// Retrofit Api With Dio
// final profileApiProvider = Provider<ProfileApi>((ref) {
//   return ApiClient(ref).create(ProfileApi.new);
// });

// /// DataSource
// final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
//   (ref) => ProfileRemoteDataSource(ref.read(profileApiProvider)),
// );

// /// Repository
// final profileRepositoryProvider = Provider<ProfileRepositoryImpl>(
//   (ref) => ProfileRepositoryImpl(
//     remoteDataSource: ref.read(profileRemoteDataSourceProvider),
//   ),
// );

// /// UseCase change password
// final changePasswordUseCaseProvider = Provider<ChangePassword>(
//   (ref) => ChangePassword(ref.read(profileRepositoryProvider)),
// );

// /// Notifier
// final changePasswordNotifierProvider =
//     StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
//       (ref) => ChangePasswordNotifier(ref.read(changePasswordUseCaseProvider)),
//     );
