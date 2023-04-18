part of 'schools_cubit.dart';

@immutable
abstract class SchoolsState {}

class SchoolsInitial extends SchoolsState {}

class SchoolsChangeBottomNavBarState extends SchoolsState {}

class SchoolsGetSupervisorSuccessState extends SchoolsState {}

class SchoolsGetSupervisorErrorState extends SchoolsState {}

class SchoolsUpdateProfileLoadingState extends SchoolsState {}

class SchoolsUpdateProfileSuccessState extends SchoolsState {}

class SchoolsUpdateProfileErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateProfileErrorState({required this.error});
}

class SchoolsUpdateProfileImageLoadingState extends SchoolsState {}

class SchoolsUpdateProfileImageSuccessState extends SchoolsState {}

class SchoolsUpdateProfileImageErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateProfileImageErrorState(this.error);
}

class SchoolsUpdateSupervisorImageLoadingState extends SchoolsState {}

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

class SchoolSignOutSuccessState extends SchoolsState {}

class SchoolSignOutErrorState extends SchoolsState {
  final String error;
  SchoolSignOutErrorState(this.error);
}

class SchoolsGetAllRequestsLoadingState extends SchoolsState {}

class SchoolsGetAllRequestsSuccessState extends SchoolsState {}

class SchoolsGetAllRequestsErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllRequestsErrorState(this.error);
}

class SchoolsGetAllChildrenLoadingState extends SchoolsState {}

class SchoolsGetAllChildrenSuccessState extends SchoolsState {}

class SchoolsGetAllChildrenErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllChildrenErrorState(this.error);
}

class SchoolsAccepteRequestLoadingState extends SchoolsState {}

class SchoolsAccepteRequestSuccessState extends SchoolsState {}

class SchoolsAccepteRequestErrorState extends SchoolsState {
  final String error;
  SchoolsAccepteRequestErrorState(this.error);
}

class SchoolsGetChildForRequestLoadingState extends SchoolsState {}

class SchoolsGetChildForRequestSuccessState extends SchoolsState {}

class SchoolsGetChildForRequestErrorState extends SchoolsState {
  final String error;
  SchoolsGetChildForRequestErrorState(this.error);
}

class SchoolsRejectRequestLoadingState extends SchoolsState {}

class SchoolsRejectRequestSuccessState extends SchoolsState {}

class SchoolsRejectRequestErrorState extends SchoolsState {
  final String error;
  SchoolsRejectRequestErrorState(this.error);
}

class SchoolsAddChildrenToClassLoadingState extends SchoolsState {}

class SchoolsAddChildrenToClassSuccessState extends SchoolsState {}

class SchoolsAddChildrenToClassErrorState extends SchoolsState {
  final String error;
  SchoolsAddChildrenToClassErrorState(this.error);
}

class SchoolsGetAllActivitiesLoadingState extends SchoolsState {}

class SchoolsGetAllActivitiesSuccessState extends SchoolsState {}

class SchoolsGetAllActivitiesErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllActivitiesErrorState(this.error);
}

class SchoolsGetAllChildrenClassLoadingState extends SchoolsState {}

class SchoolsGetAllChildrenClassSuccessState extends SchoolsState {}

class SchoolsGetAllChildrenClassErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllChildrenClassErrorState(this.error);
}

class SchoolsGetAllActivitiesJoinRequestsLoadingState extends SchoolsState {}

class SchoolsGetAllActivitiesJoinRequestsSuccessState extends SchoolsState {}

class SchoolsGetAllActivitiesJoinRequestsErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllActivitiesJoinRequestsErrorState(this.error);
}

class SchoolsAcceptActivitiesJoinRequestLoadingState extends SchoolsState {}

class SchoolsAcceptActivitiesJoinRequestSuccessState extends SchoolsState {}

class SchoolsAcceptActivitiesJoinRequestErrorState extends SchoolsState {
  final String error;
  SchoolsAcceptActivitiesJoinRequestErrorState(this.error);
}

class SchoolsGetParentForChildRequestLoadingState extends SchoolsState {}

class SchoolsGetParentForChildRequestSuccessState extends SchoolsState {}

class SchoolsGetParentForChildRequestErrorState extends SchoolsState {
  final String error;
  SchoolsGetParentForChildRequestErrorState(this.error);
}

class SchoolsUpdateClassLoadingState extends SchoolsState {}

class SchoolsUpdateClassSuccessState extends SchoolsState {}

class SchoolsUpdateClassErrorState extends SchoolsState {
  final String error;
  SchoolsUpdateClassErrorState(this.error);
}

class SchoolsUnTrackingChildLoadingState extends SchoolsState {}

class SchoolsUnTrackingChildSuccessState extends SchoolsState {}

class SchoolsUnTrackingChildErrorState extends SchoolsState {
  final String error;
  SchoolsUnTrackingChildErrorState(this.error);
}

class SchoolSendMessageLoadingState extends SchoolsState {}

class SchoolSendMessageSuccessState extends SchoolsState {}

class SchoolSendMessageErrorState extends SchoolsState {
  final String error;
  SchoolSendMessageErrorState({required this.error});
}

class SchoolGetMessagesLoadingState extends SchoolsState {}

class SchoolGetMessagesSuccessState extends SchoolsState {}

class SchoolGetMessagesErrorState extends SchoolsState {
  final String error;
  SchoolGetMessagesErrorState(this.error);
}

class SchoolsGetAllReportsLoadingState extends SchoolsState {}

class SchoolsGetAllReportsSuccessState extends SchoolsState {}

class SchoolsGetAllReportsErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllReportsErrorState(this.error);
}

class SchoolsGetAllAttendListLoadingState extends SchoolsState {}

class SchoolsGetAllAttendListSuccessState extends SchoolsState {}

class SchoolsGetAllChildrenInActivitiesLoadingState extends SchoolsState {}

class SchoolsGetAllChildrenInActivitiesSuccessState extends SchoolsState {}

class SchoolsGetAllChildrenInActivitiesErrorState extends SchoolsState {
  final String error;
  SchoolsGetAllChildrenInActivitiesErrorState(this.error);
}

class SchoolsRejectedActivityRequestLoadingState extends SchoolsState {}

class SchoolsRejectedActivityRequestSuccessState extends SchoolsState {}

class SchoolsRejectedActivityRequestErrorState extends SchoolsState {
  final String error;
  SchoolsRejectedActivityRequestErrorState(this.error);
}
