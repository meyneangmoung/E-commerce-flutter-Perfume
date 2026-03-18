import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://localhost:5000/api/auth";

  Future<String?> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["token"] != null) {
        await saveToken(data["token"]);
      }
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data["msg"] ?? data["message"] ?? "Signup failed";
    }
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["token"] != null) {
        await saveToken(data["token"]);
      }
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data["msg"] ?? data["message"] ?? "Login failed";
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwt_token", token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
  }
}