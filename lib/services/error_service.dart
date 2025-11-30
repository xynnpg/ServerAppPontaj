import 'dart:async';

enum NotificationType { error, success, info }

class NotificationEvent {
  final String message;
  final NotificationType type;

  NotificationEvent({required this.message, required this.type});
}

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

  final _notificationController =
      StreamController<NotificationEvent>.broadcast();
  Stream<NotificationEvent> get notificationStream =>
      _notificationController.stream;

  final List<ErrorLog> _errorLogs = [];
  List<ErrorLog> get errorLogs => List.unmodifiable(_errorLogs);

  void logInfo(String message, {String? input, String? output}) {
    // Log info but don't show error notification by default
    final log = ErrorLog(
      message: message,
      timestamp: DateTime.now(),
      input: input,
      output: output,
    );
    _errorLogs.add(log);
  }

  void showError(
    String message, {
    String? input,
    String? output,
    StackTrace? stackTrace,
    bool notifyUser = true,
    String? notificationMessage,
  }) {
    final log = ErrorLog(
      message: message,
      timestamp: DateTime.now(),
      input: input,
      output: output,
      stackTrace: stackTrace,
    );
    _errorLogs.add(log);

    if (notifyUser) {
      _notificationController.add(
        NotificationEvent(
          message: notificationMessage ?? message,
          type: NotificationType.error,
        ),
      );
    }
  }

  void showSuccess(String message) {
    _notificationController.add(
      NotificationEvent(message: message, type: NotificationType.success),
    );
  }

  void clearLogs() {
    _errorLogs.clear();
  }

  void dispose() {
    _notificationController.close();
  }
}
