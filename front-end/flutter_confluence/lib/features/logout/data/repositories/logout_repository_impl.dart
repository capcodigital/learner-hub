import '/features/logout/data/datasources/logout_data_source.dart';
import '/features/logout/domain/repositories/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  LogoutRepositoryImpl({required this.dataSource});

  final LogoutDataSource dataSource;

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }
}
