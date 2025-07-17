import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application/models/user_model.dart';

class ApiService {
  final String _baseUrl = "https://reqres.in/api/users";

  Future<List<User>> fetchUsers(int page, int perPage) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?page=$page&per_page=$perPage'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> userList = data['data'];
        return userList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}
