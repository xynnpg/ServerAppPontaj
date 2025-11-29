import 'dart:async';

class ErrorLog {
  final String message;
  final DateTime timestamp;
  final String? input;
  final String? output;
  final StackTrace? stackTrace;

  ErrorLog({
    required this.message,
    required this.timestamp,
    this.input,
    this.output,
    this.stackTrace,
  });
}

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final _errorController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _errorController.stream;

  final List<ErrorLog> _errorLogs = [];
  List<ErrorLog> get errorLogs => List.unmodifiable(_errorLogs);

  void showError(
    String message, {
    String? input,
    String? output,
    StackTrace? stackTrace,
  }) {
    final log = ErrorLog(
      message: message,
      timestamp: DateTime.now(),
      input: input,
      output: output,
      stackTrace: stackTrace,
    );
    _errorLogs.add(log);
    _errorController.add(message);
  }

  void clearLogs() {
    _errorLogs.clear();
  }

  void dispose() {
    _errorController.close();
  }
}
