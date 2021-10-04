import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:platform/platform.dart';

import '/core/device.dart';
import '/core/network/network_info.dart';
import '/features/auth/data/datasources/auth_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/domain/repositories/auth_repository.dart';
import '/features/auth/domain/usecases/logout.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/certifications/data/datasources/certification_hive_helper.dart';
import '/features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import '/features/certifications/data/datasources/cloud_certification_remote_data_source.dart';
import '/features/certifications/data/repositories/cloud_certifications_repository_impl.dart';
import '/features/certifications/domain/repositories/cloud_certification_repository.dart';
import '/features/certifications/domain/usecases/get_completed_certifications.dart';
import '/features/certifications/domain/usecases/get_in_progress_certifications.dart';
import '/features/certifications/domain/usecases/search_certifications.dart';
import '/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import '/features/user_registration/data/datasources/register_user_data_source.dart';
import '/features/user_registration/data/repositories/user_registration_repository_impl.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';
import '/features/user_registration/domain/usecases/register_user.dart';
import '/features/user_registration/presentation/bloc/user_registration_bloc.dart';
import 'features/auth/domain/usecases/is_session_valid.dart';
import 'features/auth/domain/usecases/login.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => CloudCertificationBloc(completedUseCase: sl(), inProgressUseCase: sl(), searchUserCase: sl()));
  sl.registerLazySingleton(() => GetCompletedCertifications(sl()));
  sl.registerLazySingleton(() => GetInProgressCertifications(sl()));
  sl.registerLazySingleton(() => SearchCertifications(sl()));
  sl.registerLazySingleton(() => CertificationHiveHelper());

  sl.registerLazySingleton<CloudCertificationRepository>(
    () => CloudCertificationsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<CloudCertificationRemoteDataSource>(
    () => CloudCertificationRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CloudCertificationLocalDataSource>(
    () => CloudCertificationLocalDataSourceImpl(hiveHelper: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => LocalAuthentication());
  sl.registerLazySingleton<Platform>(() => const LocalPlatform());
  sl.registerLazySingleton<Device>(() => DeviceImpl(platform: sl()));

  // Auth / Firebase auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthDataSource>(() => FirebaseAuthDataSourceImpl(auth: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authDataSource: sl()));
  sl.registerLazySingleton<IsSessionValisUseCase>(() => IsSessionValisUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(logoutRepository: sl()));
  sl.registerFactory(() => AuthBloc(
        isSessionValidUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // User registration
  sl.registerLazySingleton<RegisterUserDataSource>(() => RegisterUserDataSourceImpl(auth: sl(), client: sl()));
  sl.registerLazySingleton<UserRegistrationRepository>(() => UserRegistrationRepositoryIml(dataSource: sl()));
  sl.registerLazySingleton(() => RegisterUser(registrationRepository: sl()));
  sl.registerFactory(() => UserRegistrationBloc(registerUser: sl()));
}
