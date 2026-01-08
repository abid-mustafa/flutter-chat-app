import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/features/auth/presentation/pages/login.dart';
import 'package:flutter_chat_app/features/auth/presentation/pages/signup.dart';
import 'package:flutter_chat_app/features/home/home.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isAuth = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (!isAuth && !isAuthRoute) {
      return '/login';
    }

    if (isAuth && isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return HomePage();
      },
    ),
  ],
);
