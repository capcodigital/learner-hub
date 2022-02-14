class ServerException implements Exception {
  ServerException({required this.message});
  final String message;
}

class CacheException implements Exception {}

class AuthNotSupportedPlatform implements Exception {}
