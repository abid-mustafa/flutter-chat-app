import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/chat_list.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome ${user.name}'),
              centerTitle: true,
              backgroundColor: Colors.cyan,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  tooltip: 'Create a chat',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                ),
              ],
            ),
            body: Row(
              children: [
                Flexible(flex: 1, child: ChatListPage(userId: user.id)),
                Flexible(flex: 3, child: Placeholder()),
              ],
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
