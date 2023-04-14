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

class ParentGetAllSchoolsLoadingState extends ParentState {}

class ParentGetAllSchoolsSuccessState extends ParentState {}

class ParentGetAllSchoolsTeachersLoadingState extends ParentState {}

class ParentGetAllSchoolsTeachersSuccessState extends ParentState {}

class ParentGetAllSchoolsTeachersErrorState extends ParentState {}

class ParentGetAllSchoolsActivityLoadingState extends ParentState {}

class ParentGetAllSchoolsActivitySuccessState extends ParentState {}

class ParentGetSchoolByLocationLoadingState extends ParentState {}

class ParentGetSchoolByLocationSuccessState extends ParentState {}

class ParentGetSchoolByLocationErrorState extends ParentState {}

class ParentGetAllChildrenLoadingState extends ParentState {}

class ParentGetAllChildrenSuccessState extends ParentState {}

class ParentGetAllChildrenErrorState extends ParentState {
  final String error;
  ParentGetAllChildrenErrorState({required this.error});
}

class ParentAddRequestToSchoolLoadingState extends ParentState {}

class ParentAddRequestToSchoolSuccessState extends ParentState {}

class ParentAddRequestToSchoolErrorState extends ParentState {
  final String error;
  ParentAddRequestToSchoolErrorState({required this.error});
}

class ParentUpdateProfileLoadingState extends ParentState {}

class ParentUpdateProfileSuccessState extends ParentState {}

class ParentUpdateProfileErrorState extends ParentState {
  final String error;
  ParentUpdateProfileErrorState({required this.error});
}

class ParentGetAllRequestsLoadingState extends ParentState {}

class ParentCreateActivityJoinLoadingState extends ParentState {}

class ParentGetAllRequestsSuccessState extends ParentState {}

class ParentCreateActivityJoinSuccessState extends ParentState {}

class ParentCreateActivityJoinErrorState extends ParentState {
  final String error;
  ParentCreateActivityJoinErrorState({required this.error});
}

class ParentSendMessageLoadingState extends ParentState {}

class ParentSendMessageSuccessState extends ParentState {}

class ParentSendMessageErrorState extends ParentState {
  final String error;
  ParentSendMessageErrorState({required this.error});
}

class ParentGetMessagesLoadingState extends ParentState {}

class ParentGetMessagesSuccessState extends ParentState {}
