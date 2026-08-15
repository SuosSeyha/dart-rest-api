import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../lib/database/database.dart';
import '../lib/repositories/user_repository.dart';
import '../lib/routes/user_routes.dart';

Future<void> main() async {
  print('');
  print('======================================');
  print('🚀 Starting Dart REST API');
  print('======================================');
  print('');

  // ============================================================
  // DATABASE
  // ============================================================

  try {
    await Database.instance.connect();
  } catch (e) {
    print('❌ PostgreSQL connection failed');
    print(e);

    exit(1);
  }

  // ============================================================
  // REPOSITORY
  // ============================================================

  final userRepository = UserRepository();

  // ============================================================
  // ROUTES
  // ============================================================

  final userRoutes = UserRoutes(
    userRepository,
  );

  // ============================================================
  // HANDLER
  // ============================================================

  final handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addMiddleware(
        _corsMiddleware(),
      )
      .addHandler(
        (Request request) async {
          final method = request.method;
          final path = request.url.path;

          print('➡️ $method /$path');

          // ======================================================
          // CORS PREFLIGHT
          // ======================================================

          if (method == 'OPTIONS') {
            return Response.ok('');
          }

          // ======================================================
          // API HEALTH CHECK
          // ======================================================

          if (method == 'GET' && path.isEmpty) {
            return Response.ok(
              'Dart REST API is running 🚀',
              headers: {
                'content-type': 'text/plain',
              },
            );
          }

          // ======================================================
          // SWAGGER UI
          // GET /docs
          // ======================================================

          if (method == 'GET' && path == 'docs') {
            return _swaggerUi();
          }

          // ======================================================
          // OPENAPI YAML
          // GET /docs/openapi.yaml
          // ======================================================

          if (
            method == 'GET' &&
            path == 'docs/openapi.yaml'
          ) {
            return _openApiYaml();
          }

          // ======================================================
          // GET ALL USERS
          // GET /api/users
          // ======================================================

          if (
            method == 'GET' &&
            path == 'api/users'
          ) {
            return userRoutes.getUsers(
              request,
            );
          }

          // ======================================================
          // CREATE USER
          // POST /api/users
          // ======================================================

          if (
            method == 'POST' &&
            path == 'api/users'
          ) {
            return userRoutes.createUser(
              request,
            );
          }

          // ======================================================
          // USER ID ROUTES
          // ======================================================

          if (path.startsWith('api/users/')) {
            final parts = path.split('/');

            if (parts.length != 3) {
              return Response.notFound(
                'Route not found',
              );
            }

            final idString = parts[2];

            final id = int.tryParse(
              idString,
            );

            if (id == null) {
              return Response(
                400,
                body: 'Invalid user ID',
                headers: {
                  'content-type': 'text/plain',
                },
              );
            }

            // ====================================================
            // GET USER
            // ====================================================

            if (method == 'GET') {
              return userRoutes.getUser(
                request,
                id,
              );
            }

            // ====================================================
            // UPDATE USER
            // ====================================================

            if (method == 'PUT') {
              return userRoutes.updateUser(
                request,
                id,
              );
            }

            // ====================================================
            // DELETE USER
            // ====================================================

            if (method == 'DELETE') {
              return userRoutes.deleteUser(
                request,
                id,
              );
            }
          }

          // ======================================================
          // 404
          // ======================================================

          return Response.notFound(
            'Route not found',
          );
        },
      );

  // ============================================================
  // START SERVER
  // ============================================================

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
    '🌐 API: http://localhost:${server.port}',
  );

  print(
    '📚 Swagger: http://localhost:${server.port}/docs',
  );

  print(
    '📄 OpenAPI: http://localhost:${server.port}/docs/openapi.yaml',
  );

  print('======================================');
  print('');
}

// ================================================================
// SWAGGER UI
// ================================================================

Future<Response> _swaggerUi() async {
  final file = File(
    'web/swagger/index.html',
  );

  if (!await file.exists()) {
    return Response.notFound(
      'Swagger UI file not found',
    );
  }

  final content = await file.readAsString();

  return Response.ok(
    content,
    headers: {
      'content-type':
          'text/html; charset=utf-8',
    },
  );
}

// ================================================================
// OPENAPI YAML
// ================================================================

Future<Response> _openApiYaml() async {
  final file = File(
    'docs/openapi.yaml',
  );

  if (!await file.exists()) {
    return Response.notFound(
      'OpenAPI specification not found',
    );
  }

  final content = await file.readAsString();

  return Response.ok(
    content,
    headers: {
      'content-type':
          'application/yaml; charset=utf-8',
    },
  );
}

// ================================================================
// CORS
// ================================================================

Middleware _corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final response = await handler(
        request,
      );

      return response.change(
        headers: {
          ...response.headers,
          'access-control-allow-origin': '*',
          'access-control-allow-methods':
              'GET, POST, PUT, DELETE, OPTIONS',
          'access-control-allow-headers':
              'Origin, Content-Type, Accept, Authorization',
        },
      );
    };
  };
}