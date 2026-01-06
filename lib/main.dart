import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/app_router.dart';
import 'package:flutter_chat_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:flutter_chat_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_chat_app/features/auth/data/repositories/user_repository.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  final authRepository = AuthRepository(
    remoteDataSource: AuthRemoteDataSource(),
    userRepository: UserRepository(),
  );

  // final messageRepository = MessageRepositoryImpl(
  //   firestore: FirebaseFirestore.instance,
  // );

  // Initialize HydratedBloc
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        // BlocProvider<GroupBloc>(
        //   create: (context) => GroupBloc(
        //     groupRepository: groupRepository,
        //     joinGroupUseCase: joinGroupUseCase,
        //   ),
        // ),
        // BlocProvider<MessagesBloc>(
        //   create: (context) =>
        //       MessagesBloc(messagesRepository: messageRepository),
        // ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Colors.blue),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          floatingLabelStyle: TextStyle(color: Colors.blue),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
