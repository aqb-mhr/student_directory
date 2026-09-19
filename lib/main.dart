import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/user_list_screen.dart';
import 'services/api_service.dart';
import 'viewmodels/user_view_model.dart';

void main() => runApp(const StudentDirectoryApp());

class StudentDirectoryApp extends StatelessWidget {
  const StudentDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<UserViewModel>(
          create: (c) => UserViewModel(c.read<ApiService>())..loadUsers(),
        ),
      ],
      child: MaterialApp(
        title: 'Student Directory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const UserListScreen(),
      ),
    );
  }
}
