import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user_view_model.dart';
import '../widgets/user_list_view.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _controller = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _searching = !_searching);
    if (!_searching) {
      _controller.clear();
      context.read<UserViewModel>().setQuery('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserViewModel>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searching
              ? TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    border: InputBorder.none,
                  ),
                  onChanged: vm.setQuery,
                )
              : const Text('Student Directory'),
          actions: [
            IconButton(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'All Users'), Tab(text: 'Favorites')],
          ),
        ),
        body: const TabBarView(
          children: [
            UserListView(favoritesOnly: false),
            UserListView(favoritesOnly: true),
          ],
        ),
      ),
    );
  }
}
