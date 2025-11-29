import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/error_service.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final _errorService = ErrorService();

  @override
  Widget build(BuildContext context) {
    final logs = _errorService.errorLogs;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Debug Console'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _errorService.clearLogs();
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logs cleared')));
            },
            tooltip: 'Clear all logs',
          ),
        ],
      ),
      body: logs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No errors logged',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[logs.length - 1 - index]; // Reverse order
                return _buildLogCard(log, index);
              },
            ),
    );
  }

  Widget _buildLogCard(ErrorLog log, int index) {
    final formatter = DateFormat('HH:mm:ss');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: Colors.red.shade700),
          ),
          title: Text(
            log.message,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formatter.format(log.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          children: [
            if (log.input != null) ...[
              _buildDetailSection('Input', log.input!, Colors.blue),
              const SizedBox(height: 12),
            ],
            if (log.output != null) ...[
              _buildDetailSection('Output', log.output!, Colors.orange),
              const SizedBox(height: 12),
            ],
            _buildDetailSection('Full Message', log.message, Colors.red),
            if (log.stackTrace != null) ...[
              const SizedBox(height: 12),
              _buildDetailSection(
                'Stack Trace',
                log.stackTrace.toString(),
                Colors.purple,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getShade700(color),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            content,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Color _getShade700(Color color) {
    // Create a darker version of the color
    return Color.fromRGBO(
      (color.red * 0.7).round(),
      (color.green * 0.7).round(),
      (color.blue * 0.7).round(),
      1,
    );
  }
}
