part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthCreateAccountLoadingState extends AuthState {}

class AuthCreateAccountSuccessState extends AuthState {}

class AuthCreateAccountErrorState extends AuthState {
  final String error;
  AuthCreateAccountErrorState(this.error);
}

class AuthGetUserAfterLoginLoadingState extends AuthState {}

class AuthGetUserAfterLoginSuccessState extends AuthState {
  final String message;
  AuthGetUserAfterLoginSuccessState(this.message);
}

class AuthGetUserAfterLoginErrorState extends AuthState {
  final String error;
  AuthGetUserAfterLoginErrorState(this.error);
}
