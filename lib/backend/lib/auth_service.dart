import 'dart:io';
import 'package:crypt/crypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// Use the 'as mongo' alias to prevent conflicts
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AuthService {
  final mongo.DbCollection users;

  String get jwtSecret => Platform.environment['JWT_SECRET'] ?? "default_secret_key";

  AuthService(this.users);

  Future<Map<String, dynamic>?> register(String email, String password) async {
    // FIX: Using mongo.where (explicit) instead of just 'where'
    final existingUser = await users.findOne(mongo.where.eq('email', email));

    if (existingUser != null) return null;

    final hashedPassword = Crypt.sha256(password).toString();
    final userId = mongo.ObjectId();

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
    // FIX: Using mongo.where (explicit)
    final user = await users.findOne(mongo.where.eq('email', email));

    if (user == null) return null;

    final storedHash = user['password'] as String;

    if (Crypt(storedHash).match(password)) {
      final token = JWT({
        'id': (user['_id'] as mongo.ObjectId).toHexString()
      }).sign(SecretKey(jwtSecret));

      return {
        'token': token,
        'userId': (user['_id'] as mongo.ObjectId).toHexString()
      };
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