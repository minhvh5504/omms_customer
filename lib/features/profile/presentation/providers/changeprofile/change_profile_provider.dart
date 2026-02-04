// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../../core/network/api_client.dart';
// import '../../../data/api/profile_api.dart';
// import '../../../data/datasources/profile_remote_datasource.dart';
// import '../../../data/repositories/profile_repository_impl.dart';
// import '../../../domain/usecases/update_avatar.dart';
// import '../../../domain/usecases/update_user.dart';
// import 'change_profile_notifier.dart';

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

// /// UseCase update user
// final updateUserUseCaseProvider = Provider<UpdateUser>(
//   (ref) => UpdateUser(ref.read(profileRepositoryProvider)),
// );

// /// UseCase update avatar
// final updateAvatarUseCaseProvider = Provider<UpdateAvatar>(
//   (ref) => UpdateAvatar(ref.read(profileRepositoryProvider)),
// );

// /// Notifier
// final changeProfileNotifierProvider =
//     StateNotifierProvider<ChangeProfileNotifier, ChangeProfileState>(
//       (ref) => ChangeProfileNotifier(
//         ref.read(updateUserUseCaseProvider),
//         ref.read(updateAvatarUseCaseProvider),
//         ref,
//       ),
//     );
