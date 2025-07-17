import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/models/user_model.dart';

class UserDataProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _perPage = 10;
  String _errorMessage = '';

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get errorMessage => _errorMessage;

  Future<void> fetchInitialUsers() async {
    if (_isLoading) return;

    _users = [];
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = '';
    notifyListeners();

    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://reqres.in/api/users?page=$_currentPage&per_page=$_perPage',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _totalPages = data['total_pages'];

        final List<dynamic> userListJson = data['data'];
        final List<User> newUsers = userListJson
            .map((json) => User.fromJson(json))
            .toList();

        _users.addAll(newUsers);

        _currentPage++;

        _hasMore = _currentPage <= _totalPages;
      } else {
        _errorMessage =
            'Gagal memuat pengguna: Status code ${response.statusCode}';
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage =
          'Terjadi kesalahan: $e. Pastikan koneksi internet Anda stabil.';
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
