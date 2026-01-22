import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  // Update this with your actual Render URL (e.g., https://my-market-api.onrender.com)
  final String baseUrl = "https://your-dart-frog-app.render.com";

  // --- Local Storage Logic ---

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // --- Backend Logic (MongoDB via Dart Frog) ---

  /// Registers a new user
  Future<Map<String, dynamic>?> register(String email, String password, String userName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'userName': userName}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Should return {token, userId}
      }
      return null;
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }

  /// Logs in an existing user
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Should return {token, userId}
      }
      return null;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// Verifies if the saved token is still valid in MongoDB
  Future<bool> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30)); // Give Render time to wake up

      return response.statusCode == 200;
    } catch (e) {
      // If there's a timeout or no internet, we treat it as unauthenticated
      return false;
    }
  }
}