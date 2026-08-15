import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../repositories/user_repository.dart';

class UserRoutes {
  final UserRepository repository;

  UserRoutes(this.repository);

  Future<Response> getUsers(Request request) async {
    try {
      final users = await repository.getUsers();

      return _jsonResponse({
        'success': true,
        'data': users.map((user) => user.toJson()).toList(),
      });
    } catch (e) {
      print('❌ Get users error: $e');

      return _jsonResponse(
        {
          'success': false,
          'message': 'Failed to get users',
        },
        statusCode: 500,
      );
    }
  }

  Future<Response> getUser(
    Request request,
    int id,
  ) async {
    try {
      final user = await repository.getUserById(id);

      if (user == null) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'User not found',
          },
          statusCode: 404,
        );
      }

      return _jsonResponse({
        'success': true,
        'data': user.toJson(),
      });
    } catch (e) {
      print('❌ Get user error: $e');

      return _jsonResponse(
        {
          'success': false,
          'message': 'Failed to get user',
        },
        statusCode: 500,
      );
    }
  }

  Future<Response> createUser(Request request) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Request body is required',
          },
          statusCode: 400,
        );
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Invalid JSON',
          },
          statusCode: 400,
        );
      }

      final name = decoded['name']?.toString().trim();
      final email = decoded['email']?.toString().trim();

      if (name == null || name.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Name is required',
          },
          statusCode: 422,
        );
      }

      if (email == null || email.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Email is required',
          },
          statusCode: 422,
        );
      }

      final user = await repository.createUser(
        name: name,
        email: email,
      );

      return _jsonResponse(
        {
          'success': true,
          'message': 'User created successfully',
          'data': user.toJson(),
        },
        statusCode: 201,
      );
    } catch (e) {
      print('❌ Create user error: $e');

      return _jsonResponse(
        {
          'success': false,
          'message': 'Failed to create user',
          'error': e.toString(),
        },
        statusCode: 500,
      );
    }
  }

  Future<Response> updateUser(
    Request request,
    int id,
  ) async {
    try {
      final body = await request.readAsString();

      if (body.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Request body is required',
          },
          statusCode: 400,
        );
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Invalid JSON',
          },
          statusCode: 400,
        );
      }

      final name = decoded['name']?.toString().trim();
      final email = decoded['email']?.toString().trim();

      if (name == null || name.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Name is required',
          },
          statusCode: 422,
        );
      }

      if (email == null || email.isEmpty) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'Email is required',
          },
          statusCode: 422,
        );
      }

      final user = await repository.updateUser(
        id: id,
        name: name,
        email: email,
      );

      if (user == null) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'User not found',
          },
          statusCode: 404,
        );
      }

      return _jsonResponse({
        'success': true,
        'message': 'User updated successfully',
        'data': user.toJson(),
      });
    } catch (e) {
      print('❌ Update user error: $e');

      return _jsonResponse(
        {
          'success': false,
          'message': 'Failed to update user',
        },
        statusCode: 500,
      );
    }
  }

  Future<Response> deleteUser(
    Request request,
    int id,
  ) async {
    try {
      final deleted = await repository.deleteUser(id);

      if (!deleted) {
        return _jsonResponse(
          {
            'success': false,
            'message': 'User not found',
          },
          statusCode: 404,
        );
      }

      return _jsonResponse({
        'success': true,
        'message': 'User deleted successfully',
      });
    } catch (e) {
      print('❌ Delete user error: $e');

      return _jsonResponse(
        {
          'success': false,
          'message': 'Failed to delete user',
        },
        statusCode: 500,
      );
    }
  }

  Response _jsonResponse(
    Map<String, dynamic> data, {
    int statusCode = 200,
  }) {
    return Response(
      statusCode,
      body: jsonEncode(data),
      headers: {
        'content-type': 'application/json',
      },
    );
  }
}