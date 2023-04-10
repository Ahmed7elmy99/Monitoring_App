part of 'parent_cubit.dart';

@immutable
abstract class ParentState {}

class ParentInitial extends ParentState {}

class ParentChangeBottomNavState extends ParentState {}

class ParentSignOutSuccessState extends ParentState {}

class ParentSignOutErrorState extends ParentState {}

class ParentUpdateProfileImageLoadingState extends ParentState {}

class ParentUpdateProfileImageSuccessState extends ParentState {}

class ParentUpdateProfileImageErrorState extends ParentState {}

class ParentGetCurrentDataSuccessState extends ParentState {}

class ParentGetCurrentDataErrorState extends ParentState {}

class ParentAddChildrenLoadingState extends ParentState {}

class ParentAddChildrenSuccessState extends ParentState {}

class ParentAddChildrenErrorState extends ParentState {
  final String error;
  ParentAddChildrenErrorState({required this.error});
}
