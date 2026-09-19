sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection. Check your network and try again.');
}

class TimeoutAppException extends AppException {
  const TimeoutAppException() : super('The request timed out. The connection may be slow.');
}

class ServerException extends AppException {
  final int statusCode;
  ServerException(this.statusCode) : super('Server error (code $statusCode). Please try again later.');
}

class DataParsingException extends AppException {
  const DataParsingException() : super('Received data in an unexpected format.');
}
