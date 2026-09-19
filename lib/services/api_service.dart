import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'app_exceptions.dart';

/// Network calls only. No UI or state logic lives here.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 8);

  Future<List<UserModel>> fetchUsers() async {
    final response = await _get('/users');
    return _parse(response, (json) {
      final list = json as List;
      return list
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<UserModel> fetchUser(int id) async {
    final response = await _get('/users/$id');
    return _parse(
      response,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<http.Response> _get(String path) async {
    try {
      return await _client.get(Uri.parse('$baseUrl$path')).timeout(_timeout);
    } on TimeoutException {
      throw const TimeoutAppException();
    } on SocketException {
      throw const NoInternetException();
    } on http.ClientException {
      // Thrown instead of SocketException on web and some platforms.
      throw const NoInternetException();
    }
  }

  T _parse<T>(http.Response response, T Function(dynamic json) convert) {
    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }
    try {
      return convert(jsonDecode(response.body));
    } on FormatException {
      throw const DataParsingException();
    } on TypeError {
      // Missing or wrongly typed field inside fromJson.
      throw const DataParsingException();
    }
  }
}
