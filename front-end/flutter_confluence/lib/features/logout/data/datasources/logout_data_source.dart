import 'package:firebase_auth/firebase_auth.dart';

abstract class LogoutDataSource {
  Future<void> logout();
}

class LogoutDataSourceImpl implements LogoutDataSource {
  LogoutDataSourceImpl({required this.auth});

  FirebaseAuth auth;

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
