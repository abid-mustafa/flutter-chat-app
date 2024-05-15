// ignore_for_file: avoid_print
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/database_functions.dart';
import 'package:chat_app/providers/chat.dart';
import '../../models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSelect extends StatefulWidget {
  // Get logged in user data from login page
  final String username;
  final int userid;
  const UserSelect({super.key, required this.username, required this.userid});
  @override
  State<UserSelect> createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text('User List'),
        // actions: [
        //   const Text('Logout'),
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       Navigator.pop(context);
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => ChangeNotifierProvider(
        //             create: (context) => LoginProvider(),
        //             // Call Chat Page, sending current user data as well as selected user data
        //             child: const LoginPage(),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Center(
        // Display a list of users to select from
        child: FutureBuilder<List<User>>(
          future:
              getUsers(widget.userid), // Call the users method to fetch users
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for data, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurred while fetching data, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If data is successfully fetched, display it in a Text widget
              final users = snapshot.data;
              return ListView.builder(
                itemCount: users?.length ?? 0,
                itemBuilder: (context, index) {
                  final user = users?[index];

                  // Get user data if username is clicked on
                  return GestureDetector(
                    onTap: () {
                      print('Selected user: ${user?.username}');

                      int minId = widget.userid;
                      int maxId = user!.userid;

                      // Sort the ids
                      if (minId > maxId) {
                        int temp = minId;
                        minId = maxId;
                        maxId = temp;
                      }

                      // Create a room based on user ids
                      String roomid = '$minId$maxId';
                      print('roomid=$roomid');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (context) => ChatProvider(),
                            // Call Chat Page, sending current user data as well as selected user data
                            child: ChatPage(
                              userid: widget.userid,
                              username: widget.username,
                              otherid: user.userid,
                              othername: user.username,
                              roomid: roomid,
                            ),
                          ),
                        ),
                      );
                    },
                    // Display users
                    child: ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text('${user?.username}'),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
