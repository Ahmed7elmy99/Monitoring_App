part of 'layout_cubit.dart';

@immutable
abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class LayoutChangeBottomNavBarState extends LayoutState {}

class AuthAdminSignOutSuccessState extends LayoutState {}

class AuthAdminSignOutErrorState extends LayoutState {
  final String error;
  AuthAdminSignOutErrorState(this.error);
}

class AuthAdminSignOutLoadingState extends LayoutState {}

class AuthGetUserAfterLoginSuccessState extends LayoutState {}

class AuthGetUserAfterLoginErrorState extends LayoutState {
  final String error;
  AuthGetUserAfterLoginErrorState(this.error);
}

class LayoutUpdateUserDataLoadingState extends LayoutState {}

class LayoutUpdateUserDataSuccessState extends LayoutState {}

class LayoutUpdateUserDataErrorState extends LayoutState {
  final String error;
  LayoutUpdateUserDataErrorState(this.error);
}

//update user image
class LayoutGetImageSuccessState extends LayoutState {}

class LayoutGetImageErrorState extends LayoutState {}

class LayoutUpdateUserImageLoadingState extends LayoutState {}

class LayoutUpdateUserImageSuccessState extends LayoutState {}

class LayoutUpdateUserImageErrorState extends LayoutState {
  final String error;
  LayoutUpdateUserImageErrorState(this.error);
}

class LayoutCreateAdminAccountLoadingState extends LayoutState {}

class LayoutCreateAdminAccountSuccessState extends LayoutState {}

class LayoutCreateAdminAccountErrorState extends LayoutState {
  final String error;
  LayoutCreateAdminAccountErrorState(this.error);
}

class LayoutGetAllAdminsLoadingState extends LayoutState {}

class LayoutGetAllAdminsSuccessState extends LayoutState {}

class LayoutGetAllAdminsErrorState extends LayoutState {
  final String error;
  LayoutGetAllAdminsErrorState(this.error);
}

class LayoutUpdateAdminsDataLoadingState extends LayoutState {}

class LayoutUpdateAdminsDataSuccessState extends LayoutState {}

class LayoutUpdateAdminsDataErrorState extends LayoutState {
  final String error;
  LayoutUpdateAdminsDataErrorState(this.error);
}
