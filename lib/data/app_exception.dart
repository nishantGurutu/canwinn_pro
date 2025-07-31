class AppException implements Exception {
  final String message;
  final int? code;

  AppException({required this.message, this.code});

  @override
  String toString() {
    return 'AppException: $message (code: $code)';
  }
}

class InternetException extends AppException {
  InternetException({required String message, int? code})
      : super(message: message, code: code);
}

class RequestTimeoutException extends AppException {
  RequestTimeoutException({required String message, int? code})
      : super(message: message, code: code);
}

class ServerException extends AppException {
  ServerException({required String message, int? code})
      : super(message: message, code: code);
}

class UnauthorizedException extends AppException {
  UnauthorizedException({required String message, int? code})
      : super(message: message, code: code);
}

class NotFoundException extends AppException {
  NotFoundException({required String message, int? code})
      : super(message: message, code: code);
}

class BadRequestException extends AppException {
  BadRequestException({required String message, int? code})
      : super(message: message, code: code);
}
