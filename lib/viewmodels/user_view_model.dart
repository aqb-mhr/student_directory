import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/app_exceptions.dart';

enum LoadState { loading, success, error }

class UserViewModel extends ChangeNotifier {
  UserViewModel(this._api);

  final ApiService _api;

  LoadState _state = LoadState.loading;
  List<UserModel> _users = [];
  final Set<int> _favoriteIds = {}; // in memory only
  String _query = '';
  AppException? _error;

  LoadState get state => _state;
  AppException? get error => _error;
  String get query => _query;

  /// Fetches users. Returns the error (if any) so callers such as
  /// pull-to-refresh can show a SnackBar while keeping the current list.
  Future<AppException?> loadUsers({bool showSpinner = true}) async {
    if (showSpinner) {
      _state = LoadState.loading;
      notifyListeners();
    }
    AppException? failure;
    try {
      _users = await _api.fetchUsers();
      _error = null;
      _state = LoadState.success;
    } on AppException catch (e) {
      failure = e;
      _error = e;
      if (showSpinner || _users.isEmpty) _state = LoadState.error;
    }
    notifyListeners();
    return failure;
  }

  /// Filters the already-fetched list locally. No API call per keystroke.
  List<UserModel> visibleUsers({required bool favoritesOnly}) {
    final q = _query.trim().toLowerCase();
    return _users.where((u) {
      if (favoritesOnly && !_favoriteIds.contains(u.id)) return false;
      return q.isEmpty || u.name.toLowerCase().contains(q);
    }).toList();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  void toggleFavorite(int id) {
    if (!_favoriteIds.remove(id)) _favoriteIds.add(id);
    notifyListeners();
  }
}
