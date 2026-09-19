import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/app_exceptions.dart';
import '../widgets/info_row.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key, required this.user});

  /// Passed from the list so the screen can render immediately.
  final UserModel user;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<UserModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<UserModel> _load() =>
      context.read<ApiService>().fetchUser(widget.user.id);

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<UserModel>(
      future: _future,
      initialData: widget.user,
      builder: (context, snap) {
        final user = snap.data ?? widget.user;
        final loading = snap.connectionState == ConnectionState.waiting;
        final err = snap.error;

        return Scaffold(
          appBar: AppBar(title: Text(user.name)),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.send),
            label: const Text('Send Message'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Message sent to ${user.name}')),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              children: [
                if (loading) const LinearProgressIndicator(),
                if (err != null)
                  MaterialBanner(
                    content: Text(err is AppException
                        ? err.message
                        : 'Could not refresh profile.'),
                    actions: [TextButton(onPressed: _retry, child: const Text('Retry'))],
                  ),
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 56,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text(user.initials,
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                const SizedBox(height: 12),
                Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
                InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
                InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: '${user.address.street}, ${user.address.city}',
                ),
                InfoRow(
                  icon: Icons.business_outlined,
                  label: 'Company',
                  value: user.company.name,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
