part of 'schools_cubit.dart';

@immutable
abstract class SchoolsState {}

class SchoolsInitial extends SchoolsState {}

class SchoolsChangeBottomNavBarState extends SchoolsState {}

class SchoolsGetSupervisorSuccessState extends SchoolsState {}

class SchoolsGetSupervisorErrorState extends SchoolsState {}

class SchoolsUpdateProfileLoadingState extends SchoolsState {}

class SchoolsUpdateProfileSuccessState extends SchoolsState {}

class SchoolsUpdateProfileErrorState extends SchoolsState {}

class SchoolsUpdateProfileImageLoadingState extends SchoolsState {}

class SchoolsUpdateProfileImageSuccessState extends SchoolsState {}

class SchoolsUpdateProfileImageErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateProfileImageErrorState(this.error);
}

class SchoolsUpdateSupervisorImageSuccessState extends SchoolsState {}

class SchoolsUpdateSupervisorImageErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateSupervisorImageErrorState(this.error);
}

class SchoolsUpdateSupervisorProfileLoadingState extends SchoolsState {}

class SchoolsUpdateSupervisorProfileSuccessState extends SchoolsState {}

class SchoolsUpdateSupervisorProfileErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateSupervisorProfileErrorState(this.error);
}

class SchoolsAddTeacherLoadingState extends SchoolsState {}

class SchoolsAddTeacherSuccessState extends SchoolsState {}

class SchoolsAddTeacherErrorState extends SchoolsState {
  final String error;
  SchoolsAddTeacherErrorState(this.error);
}

class SchoolsAddClassLoadingState extends SchoolsState {}

class SchoolsAddClassSuccessState extends SchoolsState {}

class SchoolsAddClassErrorState extends SchoolsState {
  final String error;
  SchoolsAddClassErrorState(this.error);
}
