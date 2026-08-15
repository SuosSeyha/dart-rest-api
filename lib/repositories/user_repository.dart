import 'package:dart_api/model/user.dart';
import 'package:postgres/postgres.dart';

import '../database/database.dart';

class UserRepository {
  final Connection _db = Database.instance.connection;

  // ============================================================
  // GET ALL USERS
  // ============================================================

  Future<List<User>> getUsers() async {
    final result = await _db.execute(
      Sql.named('''
        SELECT id, name, email, created_at
        FROM users
        ORDER BY id DESC
      '''),
    );

    return result.map((row) {
      return User.fromMap(row.toColumnMap());
    }).toList();
  }

  // ============================================================
  // GET USER BY ID
  // ============================================================

  Future<User?> getUserById(int id) async {
    final result = await _db.execute(
      Sql.named('''
        SELECT id, name, email, created_at
        FROM users
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(
      result.first.toColumnMap(),
    );
  }

  // ============================================================
  // CREATE USER
  // ============================================================

  Future<User> createUser({
    required String name,
    required String email,
  }) async {
    final result = await _db.execute(
      Sql.named('''
        INSERT INTO users (
          name,
          email
        )
        VALUES (
          @name,
          @email
        )
        RETURNING id, name, email, created_at
      '''),
      parameters: {
        'name': name,
        'email': email,
      },
    );

    return User.fromMap(
      result.first.toColumnMap(),
    );
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  Future<User?> updateUser({
    required int id,
    required String name,
    required String email,
  }) async {
    final result = await _db.execute(
      Sql.named('''
        UPDATE users
        SET
          name = @name,
          email = @email
        WHERE id = @id
        RETURNING id, name, email, created_at
      '''),
      parameters: {
        'id': id,
        'name': name,
        'email': email,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(
      result.first.toColumnMap(),
    );
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<bool> deleteUser(int id) async {
    final result = await _db.execute(
      Sql.named('''
        DELETE FROM users
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    return result.affectedRows > 0;
  }
}