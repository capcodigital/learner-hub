class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {}

class AuthNotSupportedPlatform implements Exception {}
