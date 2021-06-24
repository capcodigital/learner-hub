import 'package:flutter_confluence/domain/repositories/cloud_certification_repository.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'package:get_it/get_it.dart';

import 'domain/usecases/get_completed_certification.dart';
import 'domain/usecases/get_in_progress_certification.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() =>
      CloudCertificationBloc(completedUseCase: sl(), inProgressUseCase: sl()));

  sl.registerLazySingleton(() => GetCompletedCertification(sl()));

  sl.registerLazySingleton(() => GetInProgressCertification(sl()));

  // sl.registerLazySingleton<CloudCertificationRepository>(
  //   () => CloudCertificationRepositoryImpl(),
  // );
  //
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton<CloudCertificationRepository>(
  //       () => CloudCertificationRepositoryImpl(),
  // );
}
