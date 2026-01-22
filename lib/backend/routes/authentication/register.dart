import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:online_shopping/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // 1. Only allow POST requests for registration
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // 2. Parse the request body (Email and Password)
    final body = await context.request.json() as Map<String, dynamic>;
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    // Validate input
    if (email == null || password == null || email.isEmpty || password.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Email and password are required'},
      );
    }

    // 3. Access the AuthService (provided by your _middleware.dart)
    final authService = context.read<AuthService>();

    // 4. Try to register the user in MongoDB
    final result = await authService.register(email, password);

    // 5. Handle failure (e.g., user already exists)
    if (result == null) {
      return Response.json(
        statusCode: HttpStatus.conflict, // 409 Conflict
        body: {'message': 'A user with this email already exists'},
      );
    }

    // 6. Success: Return 201 Created with {token, userId}
    return Response.json(
      statusCode: HttpStatus.created,
      body: result,
    );

  } catch (e) {
    // Handle unexpected errors (like malformed JSON)
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'message': 'Server error: $e'},
    );
  }
}