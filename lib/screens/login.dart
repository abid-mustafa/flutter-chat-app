// ignore_for_file: use_build_context_synchronously, duplicate_import, avoid_print

import 'package:chat_app/providers/signup.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/screens/user_select.dart';
import 'package:chat_app/database_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/providers/login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late int userid;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    // If text fields are not empty
    if (username.text.trim().isNotEmpty && password.text.trim().isNotEmpty) {
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
      // Check if user exists
      bool exists = await getUserLogin(username.text, password.text);
      print(exists);
      // If user exists
      if (exists) {
        print('login successful');
        // Get userid from database
        userid = await getID(username.text);
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
      // Display error message for invalid input
      else {
        print('login failed');
        provider.setErrorMessage('Invalid username or password!');
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
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display error messages using LoginProvider
            Selector<LoginProvider, String>(
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
            IconButton(
              onPressed: _login,
              icon: const Icon(Icons.arrow_circle_right),
              iconSize: 50,
            ),
            // Switch to sigup page
            Row(
              children: [
                const Text("Don't have an account? Sign up."),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (context) => SignupProvider(),
                            // Call Chat Page, sending current user data as well as selected user data
                            child: const SignupPage(),
                          ),
                        ));
                  },
                  icon: const Icon(Icons.login_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
