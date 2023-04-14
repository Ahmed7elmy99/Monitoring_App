part of 'teacher_cubit.dart';

@immutable
abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class TeacherChangeBottomNavState extends TeacherState {}

class TeacherSignOutSuccessState extends TeacherState {}

class TeacherSignOutErrorState extends TeacherState {
  final String error;
  TeacherSignOutErrorState({required this.error});
}

class TeacherGetCurrentTeacherSuccessState extends TeacherState {}

class TeacherGetCurrentTeacherErrorState extends TeacherState {}

class TeacherGetAllTeachersLoadingState extends TeacherState {}

class TeacherGetAllTeachersSuccessState extends TeacherState {}

class TeacherGetAllTeachersErrorState extends TeacherState {
  final String error;
  TeacherGetAllTeachersErrorState({required this.error});
}

class TeacherGetAllClassesSuccessState extends TeacherState {}

class TeacherGetAllClassesLoadingState extends TeacherState {}

class TeacherGetAllClassesErrorState extends TeacherState {
  final String error;
  TeacherGetAllClassesErrorState({required this.error});
}

class TeacherGetAllChildrenClassLoadingState extends TeacherState {}

class TeacherGetAllChildrenClassSuccessState extends TeacherState {}

class TeacherGetAllChildrenClassErrorState extends TeacherState {
  final String error;
  TeacherGetAllChildrenClassErrorState({required this.error});
}

class TeacherGetChildrenDataLoadingState extends TeacherState {}

class TeacherGetChildrenDataSuccessState extends TeacherState {}

class TeacherGetChildrenDataErrorState extends TeacherState {
  final String error;
  TeacherGetChildrenDataErrorState({required this.error});
}

class TeacherUpdateProfileLoadingState extends TeacherState {}

class TeacherUpdateProfileSuccessState extends TeacherState {}

class TeacherUpdateProfileErrorState extends TeacherState {
  final String error;
  TeacherUpdateProfileErrorState({required this.error});
}

class TeacherSchedulesAttendLoadingState extends TeacherState {}

class TeacherSchedulesAttendSuccessState extends TeacherState {}

class TeacherSchedulesAttendErrorState extends TeacherState {
  final String error;
  TeacherSchedulesAttendErrorState({required this.error});
}

class TeacherChangeStatusState extends TeacherState {}
