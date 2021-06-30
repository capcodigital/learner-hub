import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'data/repositories/cloud_certifications_repository_impl.dart';
import 'core/network/network_info.dart';
import 'data/datasources/cloud_certification_local_data_source.dart';
import 'data/datasources/cloud_certification_remote_data_source.dart';
import 'domain/repositories/cloud_certification_repository.dart';
import 'features/onboarding/data/datasources/on_boarding_data_source.dart';
import 'presentation/bloc/cloud_certification_bloc.dart';
import 'domain/usecases/get_completed_certifications.dart';
import 'domain/usecases/get_in_progress_certifications.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() =>
      CloudCertificationBloc(completedUseCase: sl(), inProgressUseCase: sl()));

  sl.registerLazySingleton(() => GetCompletedCertifications(sl()));

  sl.registerLazySingleton(() => GetInProgressCertifications(sl()));

  sl.registerLazySingleton<CloudCertificationRepository>(
    () => CloudCertificationsRepositoryImpl(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<CloudCertificationRemoteDataSource>(
    () => CloudCertificationRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CloudCertificationLocalDataSource>(
    () => CloudCertificationLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton<OnBoardingDataSourceImpl>(
        () => OnBoardingDataSourceImpl(auth: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => LocalAuthentication());
}
