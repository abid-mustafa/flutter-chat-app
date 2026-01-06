import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/features/auth/data/models/user_model.dart';
import 'package:flutter_chat_app/features/auth/domain/entities/user_entity.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity> createUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
    );

    await _firestore.collection('users').doc(user.id).set(userModel.toMap());
    return userModel;
  }

  Future<UserEntity> updateUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
    );

    await _firestore.collection('users').doc(user.id).update(userModel.toMap());
    return userModel;
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Future<UserEntity> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(userId, doc.data()!);
  }

  Future<UserEntity> getUserByEmail(String email) async {
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(query.docs.first.id, query.docs.first.data());
  }

  Stream<UserEntity> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(userId, doc.data()!));
  }
}
