import 'package:chat_app/database_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/providers/login.dart';
import 'package:chat_app/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connectionTested = false;

  @override
  void initState() {
    super.initState();
    testConnectionOnLoad();
  }

  Future<void> testConnectionOnLoad() async {
    bool test = await testConnection();
    setState(() {
      _connectionTested = true;
    });
    if (!test) {
      // Show AlertDialog with error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Connection Error'),
            content: const Text(
              'The remote computer refused the network connection.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _connectionTested
          ? ChangeNotifierProvider(
              create: (context) => LoginProvider(),
              child: const LoginPage(),
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
