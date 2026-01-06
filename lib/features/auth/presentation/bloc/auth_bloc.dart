import 'package:flutter_chat_app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<FetchUser>(_onFetchUser);
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String;
      switch (type) {
        case 'AuthInitial':
          return AuthInitial.fromJson(json);
        case 'Authenticated':
          return Authenticated.fromJson(json);
        case 'Unauthenticated':
          return Unauthenticated.fromJson(json);
        default:
          return AuthInitial();
      }
    } catch (e) {
      return AuthInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is Authenticated || state is Unauthenticated) {
      return state.toJson();
    }
    return null;
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
        event.name,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<AuthState> emit) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("User not found"));
      }
    } catch (e) {
      emit(AuthError("Failed to fetch User"));
      emit(Unauthenticated());
    }
  }
}
