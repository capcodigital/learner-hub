import 'package:flutter_confluence/domain/usecases/get_cloud_certifications.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => CloudCertificationBloc(getCloudCertifications: sl()));

  sl.registerLazySingleton(() => GetCloudCertifications());
}
