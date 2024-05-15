// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/providers/login.dart';
import 'package:chat_app/providers/signup.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/database_functions.dart';
import 'package:chat_app/screens/user_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    confirmpassword.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final provider = Provider.of<SignupProvider>(context, listen: false);

    // If text fields are not empty
    if (username.text.trim().isNotEmpty &&
        password.text.trim().isNotEmpty &&
        confirmpassword.text.isNotEmpty) {
      // If passwords do not match
      if (password.text.trim() != confirmpassword.text.trim()) {
        provider.setErrorMessage('Passwords do not match');
      } else {
        bool test = await testConnection();
        if (!test) {
          // Show AlertDialog with error message
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text('Error connecting to database.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
          return;
        }
        // Check if user already exists in database
        bool exists = await getUserSignup(username.text);
        // if user exists, send error
        if (exists) {
          provider.setErrorMessage('Username already exists');
        } else {
          // Create user
          addUser(username.text.trim(), password.text);
          // Get userid
          var userid = await getID(username.text.trim());
          provider.setErrorMessage('');
          // Call UserSelect Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserSelect(username: username.text.trim(), userid: userid),
            ),
          );
        }
      }
    }
    // Display error message to fill all fields
    else {
      provider.setErrorMessage('Please fill all fields!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display error messages using SignupProvider
            Selector<SignupProvider, String>(
              selector: (_, provider) => provider.errorMessage,
              builder: (_, errorMessage, __) => errorMessage != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Card(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
            // TextField for username
            TextField(
              controller: username,
              decoration: const InputDecoration(
                hintText: 'Enter Username',
              ),
            ),
            // TextField for password
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
              ),
              obscureText: true,
            ),
            // TextField for confirmpassword
            TextField(
              controller: confirmpassword,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            IconButton(
              onPressed: _signup,
              icon: const Icon(Icons.arrow_circle_right),
              iconSize: 50,
            ),
            // Switch to login page
            Row(
              children: [
                const Text('Already have an account? Login.'),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (context) => LoginProvider(),
                            // Call Chat Page, sending current user data as well as selected user data
                            child: const LoginPage(),
                          ),
                        ));
                  },
                  icon: const Icon(Icons.login),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
