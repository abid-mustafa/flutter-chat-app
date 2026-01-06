import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/features/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  Map<String, dynamic> toJson() => {'type': 'AuthInitial'};

  factory AuthInitial.fromJson(Map<String, dynamic> json) =>
      const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  Map<String, dynamic> toJson() => {'type': 'AuthLoading'};

  factory AuthLoading.fromJson(Map<String, dynamic> json) =>
      const AuthLoading();
}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  Map<String, dynamic> toJson() => {
    'type': 'Authenticated',
    'user': user.toJson(),
  };

  factory Authenticated.fromJson(Map<String, dynamic> json) {
    return Authenticated(
      UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  Map<String, dynamic> toJson() => {'type': 'Unauthenticated'};

  factory Unauthenticated.fromJson(Map<String, dynamic> json) =>
      const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];

  @override
  Map<String, dynamic> toJson() => {'type': 'AuthError', 'message': message};

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(json['message'] as String);
  }
}
