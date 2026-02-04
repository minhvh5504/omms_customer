import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/profile_remote_datasource.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../domain/usecases/get_user.dart';
import 'profile_notifier.dart';

/// Retrofit Api With Dio
// final profileApiProvider = Provider<ProfileApi>((ref) {
//   return ApiClient(ref).create(ProfileApi.new);
// });

/// DataSource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(),
);

/// Repository
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>(
  (ref) => ProfileRepositoryImpl(
    remoteDataSource: ref.read(profileRemoteDataSourceProvider),
  ),
);

/// UseCase get review by id
final getUserUseCaseProvider = Provider<GetUser>(
  (ref) => GetUser(ref.read(profileRepositoryProvider)),
);

/// Notifier
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(ref.read(getUserUseCaseProvider), ref),
    );
