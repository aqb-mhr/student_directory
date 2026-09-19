import 'package:flutter/material.dart';

import '../services/app_exceptions.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: color),
          const SizedBox(height: 12),
          Text('No users found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final AppException error;
  final VoidCallback onRetry;

  IconData get _icon => switch (error) {
        NoInternetException() => Icons.wifi_off,
        TimeoutAppException() => Icons.timer_off,
        ServerException() => Icons.cloud_off,
        DataParsingException() => Icons.data_object,
      };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(error.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
