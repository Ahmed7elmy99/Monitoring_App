part of 'teacher_cubit.dart';

@immutable
abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class TeacherSignOutSuccessState extends TeacherState {}

class TeacherSignOutErrorState extends TeacherState {
  final String error;
  TeacherSignOutErrorState({required this.error});
}
