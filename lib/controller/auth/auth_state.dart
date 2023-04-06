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

class AuthUserLoginLoadingState extends AuthState {}

class AuthUserLoginSuccessState extends AuthState {}

class AuthUserLoginErrorState extends AuthState {
  final String error;
  AuthUserLoginErrorState(this.error);
}

class AuthGetUserAfterLoginSuccessState extends AuthState {}

class AuthGetUserAfterLoginErrorState extends AuthState {
  final String error;
  AuthGetUserAfterLoginErrorState(this.error);
}
