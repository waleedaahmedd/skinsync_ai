class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class UpdateAppException extends AppException {
  const UpdateAppException() : super('New update available');
}
