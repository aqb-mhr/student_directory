import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_detail_screen.dart';
import '../viewmodels/user_view_model.dart';
import 'state_views.dart';
import 'user_card.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key, required this.favoritesOnly});

  final bool favoritesOnly;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();

    if (vm.state == LoadState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.state == LoadState.error) {
      return ErrorView(error: vm.error!, onRetry: () => vm.loadUsers());
    }

    final users = vm.visibleUsers(favoritesOnly: favoritesOnly);

    return RefreshIndicator(
      onRefresh: () async {
        final err = await vm.loadUsers(showSpinner: false);
        if (err != null && context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.message)));
        }
      },
      child: users.isEmpty
          // A scrollable child is needed so pull-to-refresh works on empty lists.
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const EmptyView(),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              itemBuilder: (context, i) {
                final user = users[i];
                return UserCard(
                  user: user,
                  isFavorite: vm.isFavorite(user.id),
                  onFavoriteToggle: () => vm.toggleFavorite(user.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
                  ),
                );
              },
            ),
    );
  }
}
