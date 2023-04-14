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

class LayoutAddSchoolLoadingState extends LayoutState {}

class LayoutAddSchoolSuccessState extends LayoutState {}

class LayoutUpdateAdminsBanLoadingState extends LayoutState {}

class LayoutUpdateAdminsBanSuccessState extends LayoutState {}

class LayoutUpdateAdminsBanErrorState extends LayoutState {
  final String error;
  LayoutUpdateAdminsBanErrorState(this.error);
}

class LayoutAddSchoolErrorState extends LayoutState {
  final String error;
  LayoutAddSchoolErrorState(this.error);
}

class LayoutAddSchoolSupervisorLoadingState extends LayoutState {}

class LayoutAddSchoolSupervisorSuccessState extends LayoutState {}

class LayoutAddSchoolSupervisorErrorState extends LayoutState {
  final String error;
  LayoutAddSchoolSupervisorErrorState(this.error);
}

class LayoutCreateSuperVisorAccountErrorState extends LayoutState {
  final String error;
  LayoutCreateSuperVisorAccountErrorState(this.error);
}

class LayoutGetAllSchoolsLoadingState extends LayoutState {}

class LayoutGetAllSchoolsSuccessState extends LayoutState {}

class LayoutGetAllSchoolsErrorState extends LayoutState {
  final String error;
  LayoutGetAllSchoolsErrorState(this.error);
}

class LayoutChangeSchoolBanLoadingState extends LayoutState {}

class LayoutChangeSchoolBanSuccessState extends LayoutState {}

class LayoutChangeSchoolBanErrorState extends LayoutState {
  final String error;
  LayoutChangeSchoolBanErrorState(this.error);
}

class LayoutGetAllSupervisorsLoadingState extends LayoutState {}

class LayoutGetAllSupervisorsSuccessState extends LayoutState {}

class LayoutGetAllSupervisorsErrorState extends LayoutState {
  final String error;
  LayoutGetAllSupervisorsErrorState(this.error);
}

class AdminGetAllParentLoadingState extends LayoutState {}

class AdminGetAllParentSuccessState extends LayoutState {}

class AdminGetAllParentErrorState extends LayoutState {
  final String error;
  AdminGetAllParentErrorState({required this.error});
}

class AdminBanParentLoadingState extends LayoutState {}

class AdminBanParentSuccessState extends LayoutState {}

class AdminBanParentErrorState extends LayoutState {
  final String error;
  AdminBanParentErrorState({required this.error});
}

class LayoutGetAllTeachersLoadingState extends LayoutState {}

class LayoutGetAllTeachersSuccessState extends LayoutState {}

class LayoutGetAllTeachersErrorState extends LayoutState {
  final String error;
  LayoutGetAllTeachersErrorState({required this.error});
}

class LayoutGetAllChildrenLoadingState extends LayoutState {}

class LayoutGetAllChildrenSuccessState extends LayoutState {}

class LayoutGetAllChildrenErrorState extends LayoutState {
  final String error;
  LayoutGetAllChildrenErrorState({required this.error});
}
