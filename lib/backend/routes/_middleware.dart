import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/auth_service.dart';

Db? _db;

Handler middleware(Handler handler) {
  return (context) async {
    // 1. Connect to MongoDB (Render/Atlas)
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create("YOUR_MONGODB_ATLAS_CONNECTION_STRING");
      await _db!.open();
    }

    // 2. Initialize the Auth Service with the users collection
    final authService = AuthService(_db!.collection('users'));

    // 3. Provide the service so the routes can use it
    final response = await handler(
      context.provide<AuthService>(() => authService),
    );

    return response;
  };
}
