import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud_flutter_ci3/models/user.dart';

class ApiService {
  final String baseUrl =
      "https://solo.ip1.co.id/kepowapi/"; // Replace with your server URL

  // Fetch all users
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/User/getuser'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Create a user
  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/User/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

  // Update a user
  Future<void> updateUser(int id, User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/User/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/User/delete/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
