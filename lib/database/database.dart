import 'package:postgres/postgres.dart';

class Database {
  Database._();

  static final Database instance = Database._();

  late Connection connection;

  Future<void> connect() async {
    connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'dart_api_db',
        username: 'seyha',
        password: '',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );

    print('✅ PostgreSQL connected');
  }

  Future<void> close() async {
    await connection.close();
  }
}