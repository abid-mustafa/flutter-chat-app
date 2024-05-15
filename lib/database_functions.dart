// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import '../models/user.dart';
import '../models/message.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySqlErrorCode {
  static const int databaseDoesNotExist = 1049;
  static const int connectionError = 2002;
}

Future<void> checkOrCreateTable(
    String tableName, String createStatement) async {
  try {
    final conn = await getConnection();
    var result = await conn.query('''
      SELECT 1 
      FROM information_schema.tables 
      WHERE table_schema = 'cn_project' 
      AND table_name = ?
      LIMIT 1
    ''', [tableName]);
    if (result.isEmpty) {
      // Create the table if it doesn't exist
      await conn.query(createStatement);
      print('$tableName table created successfully.');
    } else {
      print('$tableName table already exists.');
    }
    await conn.close();
  } catch (e) {
    print('Error checking/creating $tableName table: $e');
  }
}

Future<bool> testConnection() async {
  final settings = ConnectionSettings(
    host: "192.168.100.195",
    port: 3306,
    user: "Abid",
    password: "OrzDqDT/[3QE7[@(",
    db: "cn_project",
  );

  // Check if you can connect to database
  try {
    final conn = await MySqlConnection.connect(settings);
    print('Connection successful: $conn');

    var users =
        'CREATE TABLE `users` (`userid` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,`username` varchar(25) NOT NULL,`password` varchar(60) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;';
    var mes =
        'CREATE TABLE `messages` (`messageid` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,`message` varchar(250) NOT NULL,`senderid` int(15) NOT NULL,`sendername` varchar(25) NOT NULL,`roomid` varchar(15) NOT NULL,`timestamp` datetime NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;';

    checkOrCreateTable('users', users);
    checkOrCreateTable('messages', mes);

    return true;
  } catch (e) {
    // Check if the exception is a SocketException with errno 1225
    if (e is SocketException && e.osError?.errorCode == 1225) {
      print('Connection refused by the remote computer.');
      // Handle the error accordingly
    } else if (e is MySqlException) {
      if (e.errorNumber == MySqlErrorCode.databaseDoesNotExist) {
        print('Database does not exist');
      } else if (e.errorNumber == MySqlErrorCode.connectionError) {
        print('mySQL server is not running');
      } else {
        print('Error: $e');
        // Handle other types of errors
      }
      return false;
    }
  }
  return false;
}

// Function to get connection
Future<MySqlConnection> getConnection() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: "192.168.100.195",
      port: 3306,
      user: "Abid",
      password: "OrzDqDT/[3QE7[@(",
      db: "cn_project"));

  print('conn=$conn');
  return conn;
}

// Function to get all users except current one
Future<List<User>> getUsers(userid) async {
  MySqlConnection conn = await getConnection();
  // Execute a query
  var results =
      await conn.query('SELECT * FROM users WHERE userid != ?', [userid]);

  await conn.close();

  if (results.isEmpty) {
    return []; // Return an empty list if no users are found
  }
  // Map to user class and return list
  return results.map((row) {
    return User(
      userid: row['userid'] as int,
      username: row['username'] as String,
      password: row['password'] as String,
    );
  }).toList();
}

// Function to get user on login page
Future<bool> getUserLogin(String username, String password) async {
  MySqlConnection conn = await getConnection();

  // Execute a query
  var results = await conn.query(
    'SELECT * FROM users WHERE username = ? AND password = ?',
    [username, password],
  );

  print(results.isNotEmpty);
  await conn.close();
  return results.isNotEmpty;
}

// Function to get user on signup page
Future<bool> getUserSignup(String username) async {
  MySqlConnection conn = await getConnection();

  // Execute a query
  var results = await conn.query(
    'SELECT * FROM users WHERE username = ?',
    [username],
  );

  print(results.isNotEmpty);
  await conn.close();
  return results.isNotEmpty;
}

// Function to get userid using username
Future<int> getID(String username) async {
  MySqlConnection conn = await getConnection();

  // Execute a query
  var results = await conn.query(
    'SELECT userid FROM users WHERE username = ?',
    [username],
  );

  await conn.close();
  return results.first[0];
}

// Fucntion to add user to database
void addUser(String username, String password) async {
  MySqlConnection conn = await getConnection();

  try {
    await conn.query(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [username, password],
    );
    print('user added succesfully');
  } catch (e) {
    print(e);
  } finally {
    await conn.close();
  }
}

// Function to retrieve chat from database
Future<List<Message>> getChat(String roomid) async {
  MySqlConnection conn = await getConnection();
  // Execute a query
  const AlertDialog(title: Text('getting chat'));
  var results = await conn.query(
    'SELECT * FROM messages WHERE roomid = ?',
    [roomid],
  );
  await conn.close();
  if (results.isEmpty) {
    return []; // Return an empty list if no messages are found
  }

  // Map to message class and return list
  return results.map((row) {
    return Message(
      message: row['message'],
      sender_id: row['senderid'],
      sender_name: row['sendername'],
      room_id: row['roomid'],
      timestamp: row['timestamp'],
    );
  }).toList();
}

// Fucntion to add a message to database
void addMessage(
    int senderid, String sendername, String message, String roomid) async {
  MySqlConnection conn = await getConnection();
  // Get the current UTC time
  DateTime utcTime = DateTime.now().toUtc();

  // Define the time difference between Karachi (UTC+5) and UTC
  Duration timeDifference = const Duration(hours: 5);

  try {
    await conn.query(
      'INSERT INTO messages (message, senderid, sendername, roomid, timestamp) VALUES (?, ?, ?, ?, ?)',
      [message, senderid, sendername, roomid, utcTime.add(timeDifference)],
      // Reset the new_messages flag
    );
  } catch (e) {
    print(e);
  } finally {
    conn.close();
  }
}
