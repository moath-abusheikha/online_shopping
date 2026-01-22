import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import '../../../services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String;
  final password = body['password'] as String;

  final authService = context.read<AuthService>();
  final result = await authService.login(email, password);

  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'message': 'Invalid credentials'},
    );
  }

  return Response.json(body: result);
}