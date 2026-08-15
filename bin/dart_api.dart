import 'package:dart_api/database/database.dart';
import 'package:dart_api/repositories/user_repository.dart';
import 'package:dart_api/routes/user_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  print('======================================');
  print('🚀 Starting Dart REST API');
  print('======================================');

  // Connect PostgreSQL

  await Database.instance.connect();

  // Create repository

  final userRepository = UserRepository();

  // Create routes

  final userRoutes = UserRoutes(
    userRepository,
  );

  // Router

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(
        (Request request) async {
          final method = request.method;
          final path = request.url.path;

          print('➡️ $method /$path');

          // ==============================================
          // GET /
          // ==============================================

          if (method == 'GET' && path.isEmpty) {
            return Response.ok(
              'Dart REST API is running 🚀',
            );
          }

          // ==============================================
          // GET /api/users
          // ==============================================

          if (method == 'GET' && path == 'api/users') {
            return userRoutes.getUsers(request);
          }

          // ==============================================
          // POST /api/users
          // ==============================================

          if (method == 'POST' && path == 'api/users') {
            return userRoutes.createUser(request);
          }

          // ==============================================
          // /api/users/:id
          // ==============================================

          if (path.startsWith('api/users/')) {
            final idString = path.split('/').last;

            final id = int.tryParse(idString);

            if (id == null) {
              return Response(
                400,
                body: 'Invalid user ID',
              );
            }

            // GET /api/users/:id

            if (method == 'GET') {
              return userRoutes.getUser(
                request,
                id,
              );
            }

            // PUT /api/users/:id

            if (method == 'PUT') {
              return userRoutes.updateUser(
                request,
                id,
              );
            }

            // DELETE /api/users/:id

            if (method == 'DELETE') {
              return userRoutes.deleteUser(
                request,
                id,
              );
            }
          }

          // ==============================================
          // 404
          // ==============================================

          return Response.notFound(
            'Route not found',
          );
        },
      );

  // Start server

  final server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    8080,
  );

  print('');
  print('======================================');
  print('✅ API SERVER RUNNING');
  print('======================================');
  print(
    '🌐 http://${server.address.host}:${server.port}',
  );
  print('======================================');
}