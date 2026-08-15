# Dart REST API

A RESTful backend API built with **Dart**, **Shelf**, and **PostgreSQL**.

This project demonstrates how to build a backend server with Dart, connect it to a PostgreSQL database, and implement a complete CRUD API for users.

The API can be consumed by Flutter, web applications, mobile applications, or any client capable of making HTTP requests.

---

# Table of Contents

* [Project Overview](#project-overview)
* [Architecture](#architecture)
* [Technology Stack](#technology-stack)
* [Project Structure](#project-structure)
* [Requirements](#requirements)
* [PostgreSQL Setup](#postgresql-setup)
* [Database Schema](#database-schema)
* [Dart Project Setup](#dart-project-setup)
* [Database Configuration](#database-configuration)
* [Running the API](#running-the-api)
* [REST API Endpoints](#rest-api-endpoints)
* [Create User](#create-user)
* [Get All Users](#get-all-users)
* [Get Single User](#get-single-user)
* [Update User](#update-user)
* [Delete User](#delete-user)
* [Checking Database Data](#checking-database-data)
* [Testing with cURL](#testing-with-curl)
* [Testing with Flutter](#testing-with-flutter)
* [HTTP Status Codes](#http-status-codes)
* [API Response Format](#api-response-format)
* [Application Flow](#application-flow)
* [Security](#security)
* [Future Improvements](#future-improvements)
* [Roadmap](#roadmap)

---

# Project Overview

This project is a backend REST API written entirely in Dart.

The API uses:

* **Dart** as the programming language
* **Shelf** as the HTTP server framework
* **PostgreSQL** as the database
* **JSON** for API communication

The main purpose of this project is to learn how Dart can be used not only for Flutter applications, but also for building real backend services.

The current API manages users and supports:

```text
Create
Read
Update
Delete
```

---

# Architecture

The application follows this architecture:

```text
                  Flutter Application
                         │
                         │
                         │ HTTP / JSON
                         │
                         ▼
                ┌───────────────────┐
                │    Dart REST API  │
                │                   │
                │      Shelf        │
                │        │          │
                │      Routes       │
                │        │          │
                │   Repositories    │
                │        │          │
                │      Models       │
                └─────────┬─────────┘
                          │
                          │ SQL
                          ▼
                ┌───────────────────┐
                │    PostgreSQL     │
                │                   │
                │   dart_api_db     │
                │        │          │
                │      users        │
                └───────────────────┘
```

The client sends an HTTP request to the Dart API.

The Dart API processes the request and communicates with PostgreSQL.

PostgreSQL stores the permanent data.

---

# Technology Stack

## Backend

```text
Dart
Shelf
```

## Database

```text
PostgreSQL
```

## API Format

```text
REST
JSON
HTTP
```

## Client

The API can be used by:

```text
Flutter
Android
iOS
Web
React
Vue
JavaScript
Postman
cURL
Any HTTP client
```

---

# Project Structure

The project uses a simple layered structure:

```text
dart_api/
│
├── bin/
│   └── dart_api.dart
│
├── lib/
│   │
│   ├── database/
│   │   └── database.dart
│   │
│   ├── models/
│   │   └── user.dart
│   │
│   ├── repositories/
│   │   └── user_repository.dart
│   │
│   └── routes/
│       └── user_routes.dart
│
├── test/
│
├── pubspec.yaml
│
├── pubspec.lock
│
└── README.md
```

---

# Folder Responsibilities

## `bin/`

Contains the application entry point.

```text
bin/dart_api.dart
```

This file:

* Starts the server
* Connects the database
* Configures routes
* Starts the HTTP server

---

## `lib/database/`

Contains database connection logic.

```text
lib/database/database.dart
```

Responsible for:

* PostgreSQL connection
* Database configuration
* Opening the database connection
* Closing the database connection

---

## `lib/models/`

Contains application models.

```text
lib/models/user.dart
```

The `User` model represents a user stored in PostgreSQL.

---

## `lib/repositories/`

Contains database operations.

```text
lib/repositories/user_repository.dart
```

Responsible for:

* SELECT
* INSERT
* UPDATE
* DELETE

The repository keeps SQL/database logic separate from HTTP routes.

---

## `lib/routes/`

Contains API endpoint logic.

```text
lib/routes/user_routes.dart
```

Responsible for:

* Reading HTTP requests
* Validating request data
* Calling repositories
* Returning JSON responses
* Handling HTTP status codes

---

# Requirements

Install the following software:

* Dart SDK
* PostgreSQL
* Git
* Optional: Postman or Insomnia

Check Dart:

```bash
dart --version
```

Check PostgreSQL:

```bash
psql --version
```

Example:

```text
Dart SDK
PostgreSQL 16.15
```

---

# PostgreSQL Setup

The project uses a PostgreSQL database called:

```text
dart_api_db
```

Create the database:

```bash
createdb dart_api_db
```

Connect to it:

```bash
psql dart_api_db
```

You should see:

```text
dart_api_db=#
```

---

# Database Schema

Create the `users` table:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

PostgreSQL should return:

```text
CREATE TABLE
```

Check the table:

```sql
\dt
```

Expected:

```text
 Schema | Name  | Type  | Owner
--------+-------+-------+-------
 public | users | table | seyha
```

---

# Users Table

The database contains the following columns:

| Column       | Type         | Description    |
| ------------ | ------------ | -------------- |
| `id`         | SERIAL       | Unique user ID |
| `name`       | VARCHAR(100) | User name      |
| `email`      | VARCHAR(255) | Unique email   |
| `created_at` | TIMESTAMP    | Creation date  |

---

# PostgreSQL User

The PostgreSQL role used by this project is:

```text
seyha
```

The database is:

```text
dart_api_db
```

The table owner is:

```text
seyha
```

You can check PostgreSQL roles using:

```sql
\du
```

---

# Dart Project Setup

Create the project:

```bash
dart create -t console dart_api
```

Enter the project:

```bash
cd dart_api
```

Install dependencies:

```bash
dart pub add shelf
dart pub add postgres
```

Or:

```bash
dart pub get
```

---

# Dependencies

The main dependencies are:

```yaml
dependencies:
  shelf: ^1.x.x
  postgres: ^3.x.x
```

The exact versions are managed by `pubspec.yaml` and `pubspec.lock`.

---

# Database Configuration

Database configuration is located at:

```text
lib/database/database.dart
```

Example:

```dart
Endpoint(
  host: 'localhost',
  port: 5432,
  database: 'dart_api_db',
  username: 'seyha',
  password: '',
)
```

Configuration:

```text
Host:
localhost

Port:
5432

Database:
dart_api_db

Username:
seyha
```

For local development, PostgreSQL can run without a password depending on the local authentication configuration.

For production, do not store database passwords directly in source code.

Use environment variables instead.

---

# Running the API

Start the server:

```bash
dart run
```

The server runs on:

```text
http://localhost:8080
```

Expected output:

```text
======================================
🚀 Starting Dart REST API
======================================

✅ PostgreSQL connected

======================================
✅ API SERVER RUNNING
======================================
🌐 http://0.0.0.0:8080
======================================
```

---

# REST API Endpoints

The API currently provides:

| Method | Endpoint         | Description      |
| ------ | ---------------- | ---------------- |
| GET    | `/`              | API health check |
| GET    | `/api/users`     | Get all users    |
| GET    | `/api/users/:id` | Get one user     |
| POST   | `/api/users`     | Create user      |
| PUT    | `/api/users/:id` | Update user      |
| DELETE | `/api/users/:id` | Delete user      |

---

# 1. API Health Check

## Request

```http
GET /
```

Example:

```bash
curl http://localhost:8080/
```

Response:

```json
{
  "success": true,
  "message": "Dart REST API is running"
}
```

---

# 2. Get All Users

## Request

```http
GET /api/users
```

Example:

```bash
curl http://localhost:8080/api/users
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Seyha",
      "email": "seyha@example.com",
      "created_at": "2026-08-15T09:00:00.000Z"
    }
  ]
}
```

---

# 3. Get One User

## Request

```http
GET /api/users/:id
```

Example:

```bash
curl http://localhost:8080/api/users/1
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Seyha",
    "email": "seyha@example.com",
    "created_at": "2026-08-15T09:00:00.000Z"
  }
}
```

If the user does not exist:

```json
{
  "success": false,
  "message": "User not found"
}
```

HTTP status:

```text
404 Not Found
```

---

# 4. Create User

## Request

```http
POST /api/users
```

Content-Type:

```text
application/json
```

Request body:

```json
{
  "name": "Seyha",
  "email": "seyha@example.com"
}
```

Using cURL:

```bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":"Seyha","email":"seyha@example.com"}'
```

Successful response:

```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": 1,
    "name": "Seyha",
    "email": "seyha@example.com",
    "created_at": "2026-08-15T09:00:00.000Z"
  }
}
```

HTTP status:

```text
201 Created
```

---

# 5. Update User

## Request

```http
PUT /api/users/:id
```

Example:

```bash
curl -X PUT http://localhost:8080/api/users/1 \
-H "Content-Type: application/json" \
-d '{"name":"Seyha Updated","email":"seyha2@example.com"}'
```

Response:

```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "id": 1,
    "name": "Seyha Updated",
    "email": "seyha2@example.com",
    "created_at": "2026-08-15T09:00:00.000Z"
  }
}
```

---

# 6. Delete User

## Request

```http
DELETE /api/users/:id
```

Example:

```bash
curl -X DELETE http://localhost:8080/api/users/1
```

Response:

```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

---

# Checking Database Data

You can directly inspect the PostgreSQL database.

Connect:

```bash
psql -U seyha -d dart_api_db
```

Then:

```sql
SELECT * FROM users;
```

Example:

```text
 id | name  |       email        |         created_at
----+-------+--------------------+----------------------------
  1 | Seyha | seyha@example.com  | 2026-08-15 09:30:21
```

---

# Useful PostgreSQL Commands

Show databases:

```sql
\l
```

Connect to database:

```sql
\c dart_api_db
```

Show tables:

```sql
\dt
```

Show table structure:

```sql
\d users
```

Show all users:

```sql
SELECT * FROM users;
```

Show specific columns:

```sql
SELECT id, name, email FROM users;
```

Find a specific user:

```sql
SELECT * FROM users
WHERE id = 1;
```

Count users:

```sql
SELECT COUNT(*) FROM users;
```

Exit PostgreSQL:

```sql
\q
```

---

# Testing with cURL

## Create

```bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":"John","email":"john@example.com"}'
```

## Read

```bash
curl http://localhost:8080/api/users
```

## Read one

```bash
curl http://localhost:8080/api/users/1
```

## Update

```bash
curl -X PUT http://localhost:8080/api/users/1 \
-H "Content-Type: application/json" \
-d '{"name":"John Updated","email":"john.updated@example.com"}'
```

## Delete

```bash
curl -X DELETE http://localhost:8080/api/users/1
```

---

# Testing with Flutter

This API can be consumed from a Flutter application using Dio.

Install Dio:

```bash
flutter pub add dio
```

Example:

```dart
import 'package:dio/dio.dart';

final dio = Dio();

Future<void> getUsers() async {
  final response = await dio.get(
    'http://10.0.2.2:8080/api/users',
  );

  print(response.data);
}
```

For an Android emulator:

```text
10.0.2.2
```

points to the development computer's localhost.

For an iOS simulator:

```text
localhost
```

can normally be used.

For a physical device, use your computer's local network IP address.

---

# API Response Format

Successful responses use:

```json
{
  "success": true,
  "data": {}
}
```

For example:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Seyha",
    "email": "seyha@example.com"
  }
}
```

Successful operations may also contain a message:

```json
{
  "success": true,
  "message": "User created successfully",
  "data": {}
}
```

Error responses use:

```json
{
  "success": false,
  "message": "User not found"
}
```

---

# HTTP Status Codes

| Status Code | Meaning               |
| ----------: | --------------------- |
|       `200` | Request successful    |
|       `201` | Resource created      |
|       `400` | Bad request           |
|       `404` | Resource not found    |
|       `422` | Validation error      |
|       `500` | Internal server error |

---

# Application Flow

When Flutter creates a user:

```text
Flutter
   │
   │ POST /api/users
   │
   │ {
   │   "name": "Seyha",
   │   "email": "seyha@example.com"
   │ }
   ▼
Dart REST API
   │
   ▼
UserRoutes
   │
   ▼
UserRepository
   │
   │ INSERT INTO users
   ▼
PostgreSQL
   │
   ▼
dart_api_db
   │
   ▼
users table
```

When Flutter requests users:

```text
Flutter
   │
   │ GET /api/users
   ▼
Dart REST API
   │
   ▼
UserRoutes
   │
   ▼
UserRepository
   │
   │ SELECT * FROM users
   ▼
PostgreSQL
   │
   ▼
User data
   │
   ▼
JSON Response
   │
   ▼
Flutter
```

---

# Repository Pattern

The project separates database operations from API routes.

The route handles:

```text
HTTP Request
Validation
HTTP Response
```

The repository handles:

```text
SQL
Database Queries
CRUD Operations
```

This makes the application easier to maintain as it grows.

Example:

```text
UserRoutes
     │
     ▼
UserRepository
     │
     ▼
PostgreSQL
```

---

# CRUD

The project implements complete CRUD functionality.

## Create

```text
POST /api/users
```

Uses:

```sql
INSERT INTO users
```

## Read

```text
GET /api/users
GET /api/users/:id
```

Uses:

```sql
SELECT
```

## Update

```text
PUT /api/users/:id
```

Uses:

```sql
UPDATE users
```

## Delete

```text
DELETE /api/users/:id
```

Uses:

```sql
DELETE FROM users
```

---

# Security

The current project is intended for learning and local development.

Before deploying to production, the following should be implemented.

## Environment Variables

Do not store database passwords directly in Dart source code.

Use environment variables such as:

```text
DATABASE_HOST
DATABASE_PORT
DATABASE_NAME
DATABASE_USERNAME
DATABASE_PASSWORD
```

## Password Hashing

If authentication is added, never store plain-text passwords.

Use secure password hashing such as:

```text
Argon2
bcrypt
```

## JWT Authentication

Protected endpoints can use:

```text
Authorization: Bearer <token>
```

## HTTPS

Production APIs should use:

```text
HTTPS
```

instead of plain HTTP.

## Input Validation

Validate:

* Email format
* String length
* Required fields
* Numeric IDs
* Request body
* Authorization

## Rate Limiting

Protect public endpoints from excessive requests.

---

# Recommended Production Architecture

As the project grows, the architecture can become:

```text
                    Flutter
                       │
                       │ HTTPS
                       ▼
                ┌───────────────┐
                │ Load Balancer │
                └───────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │  Dart API     │
                │               │
                │ Middleware    │
                │ Auth          │
                │ Routes        │
                │ Controllers   │
                │ Services      │
                │ Repositories  │
                └───────┬───────┘
                        │
              ┌─────────┴─────────┐
              │                   │
              ▼                   ▼
        PostgreSQL            Redis
        Database              Cache
```

---

# Future Features

The current project provides basic user CRUD.

Possible future features:

## Authentication

```text
POST /api/register
POST /api/login
POST /api/logout
POST /api/refresh-token
```

## User Profile

```text
GET /api/profile
PUT /api/profile
```

## Authorization

Roles such as:

```text
admin
user
moderator
```

## Pagination

Example:

```text
GET /api/users?page=1&limit=20
```

## Search

Example:

```text
GET /api/users?search=seyha
```

## Sorting

Example:

```text
GET /api/users?sort=name
```

## WebSockets

For real-time features:

```text
Dart API
    │
    └── WebSocket
          │
          ├── Chat
          ├── Notifications
          ├── Live status
          └── Real-time events
```

## Docker

Containerize:

```text
Dart API
PostgreSQL
Redis
```

## API Documentation

Add:

```text
OpenAPI
Swagger
```

---

# Roadmap

```text
[x] Dart project
[x] Shelf HTTP server
[x] PostgreSQL setup
[x] PostgreSQL users table
[x] Database connection
[x] User model
[x] User repository
[x] REST routes
[x] Create user
[x] Read users
[x] Read single user
[x] Update user
[x] Delete user
[x] JSON responses
[x] Error handling

[ ] Environment variables
[ ] Database migrations
[ ] Authentication
[ ] JWT
[ ] Password hashing
[ ] Authorization
[ ] Middleware
[ ] Pagination
[ ] Search
[ ] Validation improvements
[ ] Unit tests
[ ] Integration tests
[ ] WebSocket
[ ] Redis
[ ] Docker
[ ] CI/CD
[ ] API documentation
[ ] Production deployment
```

---

# Development Commands

Install dependencies:

```bash
dart pub get
```

Run the server:

```bash
dart run
```

Analyze code:

```bash
dart analyze
```

Run tests:

```bash
dart test
```

Format code:

```bash
dart format .
```

Upgrade packages:

```bash
dart pub upgrade
```

---

# Development Workflow

A typical development workflow is:

```text
1. Start PostgreSQL
       ↓
2. Start Dart API
       ↓
3. Test API with cURL/Postman
       ↓
4. Verify PostgreSQL data
       ↓
5. Connect Flutter application
       ↓
6. Implement new API feature
       ↓
7. Test
       ↓
8. Deploy
```

---

# Database Verification

After creating a user through the API:

```bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":"Seyha","email":"seyha@example.com"}'
```

Open PostgreSQL:

```bash
psql -U seyha -d dart_api_db
```

Then:

```sql
SELECT * FROM users;
```

If the user appears in the result, the complete flow is working:

```text
Flutter / cURL
      ↓
Dart REST API
      ↓
User Repository
      ↓
PostgreSQL
      ↓
users table
```

---

# License

This project is currently intended for learning and development purposes.
