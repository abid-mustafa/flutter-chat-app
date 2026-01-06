import 'package:flutter_chat_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:flutter_chat_app/features/auth/data/models/user_model.dart';
import 'package:flutter_chat_app/features/auth/data/repositories/user_repository.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserRepository userRepository;

  AuthRepository({
    required this.remoteDataSource,
    required this.userRepository,
  });

  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await remoteDataSource.signInWithEmailAndPassword(
      email,
      password,
    );
    final user = await userRepository.getUser(userCredential.user!.uid);
    return user as UserModel;
  }

  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final userCredential = await remoteDataSource.signUpWithEmailAndPassword(
      email,
      password,
    );
    final user = UserModel(
      id: userCredential.user!.uid,
      name: name,
      email: email,
    );
    await userRepository.createUser(user);
    return user;
  }

  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = await remoteDataSource.getCurrentUser();
    if (firebaseUser == null) return null;
    final user = await userRepository.getUser(firebaseUser.uid);
    return user as UserModel;
  }
}
