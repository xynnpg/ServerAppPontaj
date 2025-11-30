import 'dart:async';
import 'package:flutter/material.dart';
import '../services/error_service.dart';

class ErrorOverlay extends StatefulWidget {
  final Widget child;

  const ErrorOverlay({super.key, required this.child});

  @override
  State<ErrorOverlay> createState() => _ErrorOverlayState();
}

class _ErrorOverlayState extends State<ErrorOverlay>
    with SingleTickerProviderStateMixin {
  final _errorService = ErrorService();
  NotificationEvent? _currentNotification;
  Timer? _dismissTimer;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _errorService.notificationStream.listen(_showNotification);
  }

  void _showNotification(NotificationEvent event) {
    _dismissTimer?.cancel();
    setState(() {
      _currentNotification = event;
    });
    _controller.forward();

    _dismissTimer = Timer(const Duration(seconds: 4), () {
      _dismiss();
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    if (mounted) {
      setState(() {
        _currentNotification = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

  Color _getBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Colors.red.shade50;
      case NotificationType.success:
        return Colors.green.shade50;
      case NotificationType.info:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Colors.red.shade200;
      case NotificationType.success:
        return Colors.green.shade200;
      case NotificationType.info:
        return Colors.blue.shade200;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Colors.red.shade700;
      case NotificationType.success:
        return Colors.green.shade700;
      case NotificationType.info:
        return Colors.blue.shade700;
    }
  }

  Color _getTextColor(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Colors.red.shade900;
      case NotificationType.success:
        return Colors.green.shade900;
      case NotificationType.info:
        return Colors.blue.shade900;
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (_currentNotification != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _slideAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(_currentNotification!.type),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getBorderColor(_currentNotification!.type),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getIcon(_currentNotification!.type),
                        color: _getIconColor(_currentNotification!.type),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentNotification!.message,
                          style: TextStyle(
                            color: _getTextColor(_currentNotification!.type),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: _getIconColor(_currentNotification!.type),
                        ),
                        onPressed: _dismiss,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
