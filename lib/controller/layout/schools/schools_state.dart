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

class SchoolsAddActivityLoadingState extends SchoolsState {}

class SchoolsAddActivitySuccessState extends SchoolsState {}

class SchoolsAddActivityErrorState extends SchoolsState {
  final String error;
  SchoolsAddActivityErrorState(this.error);
}

class SchoolsGetAllSupervisorsLoadingState extends SchoolsState {}

class SchoolsGetAllSupervisorsSuccessState extends SchoolsState {}

class SchoolsGetAllSupervisorsErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllSupervisorsErrorState(this.error);
}

class SchoolsCreateSupervisorAccountErrorState extends SchoolsState {
  final String error;
  SchoolsCreateSupervisorAccountErrorState(this.error);
}

class SchoolsAddSupervisorLoadingState extends SchoolsState {}

class SchoolsAddSupervisorSuccessState extends SchoolsState {}

class SchoolsAddSupervisorErrorState extends SchoolsState {
  final String error;
  SchoolsAddSupervisorErrorState(this.error);
}

class SchoolsGetAllTeachersLoadingState extends SchoolsState {}

class SchoolsGetAllTeachersSuccessState extends SchoolsState {}

class SchoolsGetAllTeachersErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllTeachersErrorState(this.error);
}

class SchoolsBanTeacherSuccessState extends SchoolsState {}

class SchoolsBanTeacherErrorState extends SchoolsState {
  final String error;
  SchoolsBanTeacherErrorState(this.error);
}

class SchoolsGetAllClassesSuccessState extends SchoolsState {}

class SchoolsGetAllClassesErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllClassesErrorState(this.error);
}

class SchoolsBanSupervisorSuccessState extends SchoolsState {}

class SchoolsBanSupervisorErrorState extends SchoolsState {
  final String error;
  SchoolsBanSupervisorErrorState(this.error);
}
