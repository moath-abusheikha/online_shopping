import 'dart:io';
import 'package:crypt/crypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthService {
  final DbCollection users;

  // Use the secret from Render environment variables
  String get jwtSecret => Platform.environment['JWT_SECRET'] ?? "default_secret_key";

  AuthService(this.users);

  Future<Map<String, dynamic>?> register(String email, String password) async {
    final existingUser = await users.findOne(where.eq('email', email));
    if (existingUser != null) return null;

    final hashedPassword = Crypt.sha256(password).toString();
    final userId = ObjectId();

    await users.insertOne({
      '_id': userId,
      'email': email,
      'password': hashedPassword,
      'created_at': DateTime.now()
    });

    final token = JWT({'id': userId.toHexString()}).sign(SecretKey(jwtSecret));
    return {'token': token, 'userId': userId.toHexString()};
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final user = await users.findOne(where.eq('email', email));
    if (user == null) return null;

    final storedHash = user['password'] as String;

    if (Crypt(storedHash).match(password)) {
      final token = JWT({'id': (user['_id'] as ObjectId).toHexString()}).sign(SecretKey(jwtSecret));
      return {'token': token, 'userId': (user['_id'] as ObjectId).toHexString()};
    }
    return null;
  }

  Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(jwtSecret));
      return jwt.payload as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}