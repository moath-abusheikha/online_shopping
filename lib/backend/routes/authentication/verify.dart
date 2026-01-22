import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// Middleware to verify JWT token

Future<Response> onRequest(RequestContext context) async {
  // Only allow GET requests for verification
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final authHeader = context.request.headers['Authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response(statusCode: HttpStatus.unauthorized);
  }

  final token = authHeader.substring(7);

  try {
    // Secret key should match the one used in Login/Register
    final jwtSecret = Platform.environment['JWT_SECRET'] ?? "your_shared_secret_key";
    final jwt = JWT.verify(token, SecretKey(jwtSecret));

    // If verification passes, return 200 OK
    return Response.json(body: {'valid': true, 'userId': jwt.payload['id']});
  } catch (e) {
    return Response(statusCode: HttpStatus.unauthorized);
  }
}