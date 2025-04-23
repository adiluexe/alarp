/// Exception indicating an error during server communication.
class ServerException implements Exception {
  final String message;
  final int? statusCode; // Optional: Include status code if available

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'ServerException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
  }
}

/// Exception indicating an error during cache operations.
class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception indicating an error related to authentication.
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// General exception for unexpected errors.
class UnexpectedException implements Exception {
  final String message;
  final dynamic error; // Original error object

  UnexpectedException(this.message, [this.error]);

  @override
  String toString() {
    return 'UnexpectedException: $message${error != null ? '\nOriginal Error: $error' : ''}';
  }
}
