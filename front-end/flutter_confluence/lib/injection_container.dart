import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/core/auth/auth_manager.dart';
import 'package:flutter_confluence/core/device.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_auth_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:platform/platform.dart';
import 'package:http/http.dart' as http;

import 'core/auth/firebase_auth_manager.dart';
import 'features/certifications/data/datasources/certification_hive_helper.dart';
import 'features/certifications/domain/usecases/search_certifications.dart';
import 'features/onboarding/data/datasources/bio_auth_hive_helper.dart';
import 'features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'features/onboarding/domain/repositories/on_boarding_repository.dart';
import 'features/certifications/data/repositories/cloud_certifications_repository_impl.dart';
import 'core/network/network_info.dart';
import 'features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import 'features/certifications/data/datasources/cloud_certification_remote_data_source.dart';
import 'features/certifications/domain/repositories/cloud_certification_repository.dart';
import 'features/onboarding/data/repositories/on_boarding_repository_impl.dart';
import 'features/onboarding/domain/usecases/auth_use_case.dart';
import 'features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'features/certifications/domain/usecases/get_completed_certifications.dart';
import 'features/certifications/domain/usecases/get_in_progress_certifications.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => CloudCertificationBloc(
      completedUseCase: sl(), inProgressUseCase: sl(), searchUserCase: sl()));
  sl.registerLazySingleton(() => GetCompletedCertifications(sl()));
  sl.registerLazySingleton(() => GetInProgressCertifications(sl()));
  sl.registerLazySingleton(() => SearchCertifications(sl()));
  sl.registerLazySingleton(() => CertificationHiveHelper());
  sl.registerLazySingleton(() => BioAuthHiveHelper());


  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthManager>(() => FirebaseAuthManager(auth: sl()));

  sl.registerLazySingleton<CloudCertificationRepository>(
    () => CloudCertificationsRepositoryImpl(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
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

  sl.registerFactory(
      () => OnBoardingBloc(authUseCase: sl(), checkAuthUseCase: sl()));
  sl.registerLazySingleton<AuthUseCase>(() => AuthUseCase(sl()));
  sl.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(sl()));
  sl.registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(onBoardingDataSource: sl()));
  sl.registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(auth: sl(), authHiveHelper: sl(), device:sl()));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => LocalAuthentication());
  sl.registerLazySingleton<Platform>(() => LocalPlatform());
  sl.registerLazySingleton<Device>(() => DeviceImpl(platform: sl()));
}
