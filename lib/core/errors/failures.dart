import 'package:vibe_cafe/core/errors/exceptions.dart';

/// Base failure class
abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});
}

/// Network failure
class NetworkFailure extends Failure {
  NetworkFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Server failure (5xx errors)
class ServerFailure extends Failure {
  ServerFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Client failure (4xx errors)
class ClientFailure extends Failure {
  ClientFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory ClientFailure.fromException(ClientException exception) {
    return ClientFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  AuthenticationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory AuthenticationFailure.fromException(AuthenticationException exception) {
    return AuthenticationFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  AuthorizationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory AuthorizationFailure.fromException(AuthorizationException exception) {
    return AuthorizationFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  ValidationFailure({
    required String message,
    String? code,
    this.errors,
  }) : super(message: message, code: code);

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(
      message: exception.message,
      code: exception.code,
      errors: exception.errors,
    );
  }
}

/// Cache failure
class CacheFailure extends Failure {
  CacheFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Payment failure
class PaymentFailure extends Failure {
  PaymentFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory PaymentFailure.fromException(PaymentException exception) {
    return PaymentFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Timeout failure
class TimeoutFailure extends Failure {
  TimeoutFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory TimeoutFailure.fromException(TimeoutException exception) {
    return TimeoutFailure(
      message: exception.message,
      code: exception.code,
    );
  }
}

/// Generic failure
class GenericFailure extends Failure {
  GenericFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);

  factory GenericFailure.fromException(Exception exception) {
    return GenericFailure(
      message: exception.toString(),
      code: 'GENERIC_ERROR',
    );
  }
}
