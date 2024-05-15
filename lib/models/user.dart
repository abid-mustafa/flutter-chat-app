// Class to store user data
class User {
  final int userid;
  final String username;
  final String password;

  User({required this.userid, required this.username, required this.password});

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'userid': userid,
      'username': username,
      'password': password,
    };
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{userid: $userid, username: $username, password: $password}';
  }
}
