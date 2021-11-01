import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:flutter_confluence/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_hive_helper.dart';
import 'package:flutter_confluence/features/todo/data/repository/todo_repository_impl.dart';
import 'package:flutter_confluence/features/todo/domain/repository/todo_repository.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/create_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/delete_todo.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_confluence/features/todo/domain/usecases/update_todo.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:platform/platform.dart';

import '/core/device.dart';
import '/core/network/network_info.dart';
import '/features/auth/data/datasources/auth_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/domain/repositories/auth_repository.dart';
import '/features/auth/domain/usecases/is_session_valid.dart';
import '/features/auth/domain/usecases/login.dart';
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
import '/features/user_settings/data/datasources/user_settings_data_source.dart';
import '/features/user_settings/data/repositories/user_settings_repository_impl.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';
import '/features/user_settings/domain/usecases/load_user.dart';
import '/features/user_settings/domain/usecases/update_password.dart';
import '/features/user_settings/domain/usecases/update_user_settings.dart';
import '/features/user_settings/presentation/bloc/user_settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => CloudCertificationBloc(
      completedUseCase: sl(), inProgressUseCase: sl(), searchUserCase: sl()));
  sl.registerLazySingleton(() => GetCompletedCertifications(sl()));
  sl.registerLazySingleton(() => GetInProgressCertifications(sl()));
  sl.registerLazySingleton(() => SearchCertifications(sl()));
  sl.registerLazySingleton(() => CertificationHiveHelper());

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

  // Auth / Firebase auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthDataSource>(
      () => FirebaseAuthDataSourceImpl(auth: sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authDataSource: sl()));
  sl.registerLazySingleton<IsSessionValidUseCase>(
      () => IsSessionValidUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(logoutRepository: sl()));
  sl.registerFactory(() => AuthBloc(
        isSessionValidUseCase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // User registration
  sl.registerLazySingleton<RegisterUserDataSource>(
      () => RegisterUserDataSourceImpl(auth: sl(), client: sl()));
  sl.registerLazySingleton<UserRegistrationRepository>(
      () => UserRegistrationRepositoryIml(dataSource: sl()));
  sl.registerLazySingleton(() => RegisterUser(registrationRepository: sl()));
  sl.registerFactory(() => UserRegistrationBloc(registerUser: sl()));

  // TODOs
  // Usecases
  sl.registerLazySingleton(() => CreateTodo(repository: sl()));
  sl.registerLazySingleton(() => GetTodos(repository: sl()));
  sl.registerLazySingleton(() => UpdateTodo(repository: sl()));
  sl.registerLazySingleton(() => DeleteTodo(repository: sl()));
  // BLoC
  sl.registerFactory(() => TodoBloc(
      createTodoUsecase: sl(),
      deleteTodoUsecase: sl(),
      getTodosUsecase: sl(),
      updateTodoUsecase: sl()));
  // Helpers
  sl.registerLazySingleton(() => TodoHiveHelperImpl());
  // Repositories
  sl.registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  // Datasources
  sl.registerLazySingleton<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(auth: sl(), client: sl()));
  sl.registerLazySingleton<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(hive: sl()));

  // Misc
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => LocalAuthentication());
  sl.registerLazySingleton<Platform>(() => const LocalPlatform());
  sl.registerLazySingleton<Device>(() => DeviceImpl(platform: sl()));
  // User settings
  sl.registerLazySingleton<UserSettingsDataSource>(
      () => UserSettingsDataSourceImpl(auth: sl(), client: sl()));
  sl.registerLazySingleton<UserSettingsRepository>(
      () => UserSettingsRepositoryImpl(dataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => UpdatePassword(userSettingsRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateUserSettings(userSettingsRepository: sl()));
  sl.registerLazySingleton(() => LoadUser(userSettingsRepository: sl()));
  sl.registerFactory(() => UserSettingsBloc(
        updateUserSettings: sl(),
        updatePassword: sl(),
        loadUser: sl(),
      ));
}
