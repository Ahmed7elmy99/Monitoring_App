import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/const_data.dart';
import '../../../models/activity_join_model.dart';
import '../../../models/attend_model.dart';
import '../../../models/children_model.dart';
import '../../../models/message_model.dart';
import '../../../models/parent_model.dart';
import '../../../models/report_model.dart';
import '../../../models/school_activities_model.dart';
import '../../../models/school_join_model.dart';
import '../../../models/school_model.dart';
import '../../../models/supervisors_model.dart';
import '../../../models/teacher_model.dart';
import '../../../modules/parents/home/parent_home_screen.dart';
import '../../../modules/parents/parent_setting_screen.dart';

part 'parent_state.dart';

class ParentCubit extends Cubit<ParentState> {
  ParentCubit() : super(ParentInitial());
  static ParentCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ParentChangeBottomNavState());
  }

  List<Widget> screens = [
    const ParentHomeScreen(),
    const ParentSettingScreen(),
  ];
  List<String> titles = [
    'Home',
    'Settings',
  ];
  String parentImageUrl = '';
  File? parentImageFile;
  void updateParentProfileImage({required String userId}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      parentImageFile = File(image.path);
      parentImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$userId')
          .putFile(parentImageFile!)
          .then((p0) => {
                p0.ref.getDownloadURL().then((value) {
                  parentImageUrl = value;
                  parentImageFile = null;
                  FirebaseFirestore.instance
                      .collection('parents')
                      .doc(PARENT_MODEL!.id)
                      .update({
                    'image': parentImageUrl,
                  }).then((value) {
                    getCurrentParentData();
                    emit(ParentUpdateProfileImageSuccessState());
                  }).catchError((error) {
                    print('Error: $error');
                    emit(ParentUpdateProfileImageErrorState());
                  });
                })
              })
          .catchError((error) {
        print('Error: $error');
        emit(ParentUpdateProfileImageErrorState());
      });
    } else {
      emit(ParentUpdateProfileImageErrorState());
    }
  }

  void updateParentProfileData({
    String? name,
    String? phone,
    String? age,
    String? gender,
    String? email,
    String? password,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    emit(ParentUpdateProfileDataLoadingState());
    if (email != null && email != PARENT_MODEL?.email) {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        emit(ParentUpdateProfileDataErrorState(
            error: 'This email is already in use'));
        return; // Exit the function if the email address is already in use
      }
      await user!.updateEmail(email);
    }
    if (password != null &&
        password != PARENT_MODEL?.password &&
        password != '') {
      await user!.updatePassword(password);
      print('Success update password✨');
    }
    if (phone != null && phone != PARENT_MODEL?.phone) {
      final phoneNumbers =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(phone, phoneNumbers.docs)) {
        emit(ParentUpdateProfileDataErrorState(
            error: 'This phone number is already in use'));
        return;
      }
      await FirebaseFirestore.instance
          .collection('phoneNumbers')
          .doc(PARENT_MODEL?.id)
          .set({
        'phone': phone,
      });
    }
    await FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .update({
      'name': name == null ? PARENT_MODEL!.name : name,
      'phone': phone == null ? PARENT_MODEL!.phone : phone,
      'age': age == null ? PARENT_MODEL!.age : age,
      'email': email == null ? PARENT_MODEL!.email : email,
      'password': password == '' ? PARENT_MODEL!.password : password,
      'gender': gender,
    }).then((value) {
      getCurrentParentData();
      emit(ParentUpdateProfileDataSuccessState());
    }).catchError((error) {
      print('Error: $error');
      emit(ParentUpdateProfileDataErrorState(
          error: 'Update parent profile Error'));
    });
  }

  bool checkPhone(String phone, List<dynamic>? documents) {
    if (documents == null) {
      return false;
    }
    for (var doc in documents) {
      if (doc.data()?['phone'] == phone) {
        return true;
      }
    }
    return false;
  }

  Future<void> signOutParent() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      CacheHelper.saveData(key: 'schoolId', value: '');
      CacheHelper.saveData(key: 'user', value: '');
      currentIndex = 0;
      print('Sign Out Success🎉');
      emit(ParentSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(ParentSignOutErrorState());
    });
  }

  void getCurrentParentData() async {
    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(CacheHelper.getData(key: 'uid') == null
              ? ''
              : CacheHelper.getData(key: 'uid'))
          .snapshots()
          .listen((event) {
        PARENT_MODEL = ParentModel.fromJson(event.data()!);
        emit(ParentGetCurrentDataSuccessState());
      });
    } catch (e) {
      print('Get Parent Data Error: $e');
      emit(ParentGetCurrentDataErrorState());
    }
  }

  void addChildren({
    required String name,
    required String educationLevel,
    required String phone,
    required int age,
    required String gender,
    required String certificate,
  }) async {
    emit(ParentAddChildrenLoadingState());
    final phoneNumbers =
        await FirebaseFirestore.instance.collection('phoneNumbers').get();
    if (checkPhone(phone, phoneNumbers.docs)) {
      emit(ParentAddChildrenErrorState(
          error: 'This phone number is already in use'));
      return;
    }
    ChildrenModel childrenModel = ChildrenModel(
      id: '333333',
      parentId: PARENT_MODEL!.id,
      schoolId: '',
      classId: '',
      activityId: '',
      name: name,
      gender: gender,
      age: age,
      educationLevel: educationLevel,
      certificate: certificate,
      phone: phone,
      image: AppImages.defaultChildren,
      tracking: false,
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('children')
        .add(childrenModel.toMap())
        .then((value) {
      FirebaseFirestore.instance.collection('phoneNumbers').doc(value.id).set({
        'phone': phone,
      });
      FirebaseFirestore.instance
          .collection('parents')
          .doc(PARENT_MODEL!.id)
          .collection('children')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        print('Add Children Success🎉');
        emit(ParentAddChildrenSuccessState());
      }).catchError((error) {
        print('Add Children Error: $error');
        emit(ParentAddChildrenErrorState(
            error: 'Error: ${error.toString().split(']')[1]}'));
      });
      emit(ParentAddChildrenSuccessState());
    }).catchError((error) {
      print('Add Children Error: $error');
      emit(ParentAddChildrenErrorState(
          error: 'Error: ${error.toString().split(']')[1]}'));
    });
  }

  List<SchoolModel> parentSchoolsList = [];
  void getAllSchools() {
    emit(ParentGetAllSchoolsLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .snapshots()
        .listen((event) {
      parentSchoolsList = [];
      event.docs.forEach((element) {
        if (element.data()['ban'] != 'true') {
          parentSchoolsList.add(SchoolModel.fromJson(element.data()));
        }
      });
      emit(ParentGetAllSchoolsSuccessState());
    });
  }

  List<TeacherModel> parentSchoolsTeachersList = [];
  void getAllSchoolsTeachers({required String schoolId}) {
    emit(ParentGetAllSchoolsTeachersLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('teachers')
        .snapshots()
        .listen((event) {
      parentSchoolsTeachersList = [];
      event.docs.forEach((element) {
        parentSchoolsTeachersList.add(TeacherModel.fromJson(element.data()));
      });
      emit(ParentGetAllSchoolsTeachersSuccessState());
    });
  }

  List<SchoolActivitiesModel> parentSchoolsActivityList = [];
  void getAllSchoolsActivity({required String schoolId}) {
    emit(ParentGetAllSchoolsActivityLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('activities')
        .snapshots()
        .listen((event) {
      parentSchoolsActivityList = [];
      event.docs.forEach((element) {
        if (element.data()['activityType'] != 'pending')
          parentSchoolsActivityList
              .add(SchoolActivitiesModel.fromJson(element.data()));
      });
      emit(ParentGetAllSchoolsActivitySuccessState());
    });
  }

  List<SupervisorsModel> parentSchoolsSupervisorsList = [];
  void getAllSchoolsSupervisors({required String schoolId}) {
    emit(ParentGetAllSchoolsSupervisorsLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('supervisors')
        .snapshots()
        .listen((event) {
      parentSchoolsSupervisorsList = [];
      event.docs.forEach((element) {
        parentSchoolsSupervisorsList
            .add(SupervisorsModel.fromJson(element.data()));
      });
      emit(ParentGetAllSchoolsSupervisorsSuccessState());
    });
  }

  List<SchoolModel> parentSchoolByLocationList = [];
  void getSchoolByLocation({required String location}) async {
    emit(ParentGetSchoolByLocationLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .where('location', isGreaterThanOrEqualTo: location)
        .get()
        .then((value) {
      parentSchoolByLocationList = [];
      value.docs.forEach((element) {
        parentSchoolByLocationList.add(SchoolModel.fromJson(element.data()));
      });
      emit(ParentGetSchoolByLocationSuccessState());
    }).catchError((error) {
      parentSchoolByLocationList = [];
      print('Error: $error');
      emit(ParentGetSchoolByLocationErrorState());
    });
  }

  List<ChildrenModel> parentChildrenList = [];
  List<ChildrenModel> parentChildrenForActivityJoinList = [];
  void getAllChildren() {
    emit(ParentGetAllChildrenLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('children')
        .snapshots()
        .listen((event) {
      parentChildrenList = [];
      parentChildrenForActivityJoinList = [];
      event.docs.forEach((element) {
        parentChildrenList.add(ChildrenModel.fromJson(element.data()));
        if (element.data()['activityId'] == '') {
          parentChildrenForActivityJoinList
              .add(ChildrenModel.fromJson(element.data()));
        }
      });
      emit(ParentGetAllChildrenSuccessState());
    });
  }

  void crateActivityJoin(
      {required String activityId, required ChildrenModel childModel}) {
    emit(ParentCreateActivityJoinLoadingState());
    ActivityJoinModel activityJoinModel = ActivityJoinModel(
      id: '333333',
      childId: childModel.id,
      activityStatus: 'pending',
      schoolActivityId: activityId,
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(childModel.schoolId)
        .collection('activitiesJoin')
        .add(activityJoinModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(childModel.schoolId)
          .collection('activitiesJoin')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('parents')
            .doc(childModel.parentId)
            .collection('children')
            .doc(childModel.id)
            .update({
          'activityId': 'pending',
        });
        emit(ParentCreateActivityJoinSuccessState());
      }).catchError((error) {
        emit(ParentCreateActivityJoinErrorState(error: error.toString()));
      });
    });
  }

  String requestChildId = '';
  void addRequestToSchool({
    required String schoolId,
    required ChildrenModel childModel,
  }) {
    emit(ParentAddRequestToSchoolLoadingState());
    SchoolRequestModel schoolRequestModel = SchoolRequestModel(
        id: '333333',
        childId: childModel.id,
        schoolId: schoolId,
        requestStatus: 'pending',
        note: '',
        createdAt: DateTime.now().toString());
    if (childModel.id == '') {
      emit(ParentAddRequestToSchoolErrorState(error: 'Please Select Child'));
      return;
    }
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('requestsChildren')
        .add(schoolRequestModel.toMap())
        .then((value) {
      requestChildId = value.id;
      FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .collection('requestsChildren')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('parents')
            .doc(PARENT_MODEL!.id)
            .collection('requests')
            .doc(requestChildId)
            .set({
              'id': requestChildId,
              'childId': childModel.id,
              'schoolId': schoolId,
              'requestStatus': 'pending',
              'note': '',
              'createdAt': DateTime.now().toString(),
            })
            .then((value) {})
            .catchError((error) {
              print('Add Request Error: $error');
              emit(ParentAddRequestToSchoolErrorState(
                  error: 'Error: ${error.toString().split(']')[1]}'));
            });
        emit(ParentAddRequestToSchoolSuccessState());
      }).catchError((error) {
        print('Add Request Error: $error');
        emit(ParentAddRequestToSchoolErrorState(
            error: 'Error: ${error.toString().split(']')[1]}'));
      });
      FirebaseFirestore.instance
          .collection('parents')
          .doc(PARENT_MODEL!.id)
          .collection('children')
          .doc(childModel.id)
          .update({
        'schoolId': 'pending',
      }).then((value) {
        print('Add Request Success🎉');
        emit(ParentAddRequestToSchoolSuccessState());
      }).catchError((error) {
        print('Add Request Error: $error');
        emit(ParentAddRequestToSchoolErrorState(
            error: 'Error: ${error.toString().split(']')[1]}'));
      });
      emit(ParentAddRequestToSchoolSuccessState());
    }).catchError((error) {
      print('Add Request Error: $error');
      emit(ParentAddRequestToSchoolErrorState(
          error: 'Error: ${error.toString().split(']')[1]}'));
    });
  }

  List<SchoolRequestModel> parentSchoolRequestsList = [];
  void getAllRequests() {
    emit(ParentGetAllRequestsLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('requests')
        .snapshots()
        .listen((event) {
      parentSchoolRequestsList = [];
      event.docs.forEach((element) {
        parentSchoolRequestsList
            .add(SchoolRequestModel.fromJson(element.data()));
      });
      emit(ParentGetAllRequestsSuccessState());
    });
  }

  String childrenImageUrl = '';
  File? childrenImageFile;
  void updateChildrenProfileImage({required String userId}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      childrenImageFile = File(image.path);
      childrenImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$userId')
          .putFile(childrenImageFile!)
          .then((p0) => {
                p0.ref.getDownloadURL().then((value) {
                  childrenImageUrl = value;
                  childrenImageFile = null;
                  FirebaseFirestore.instance
                      .collection('parents')
                      .doc(PARENT_MODEL!.id)
                      .collection('children')
                      .doc(userId)
                      .update({
                    'image': childrenImageUrl,
                  }).then((value) {
                    getAllChildren();
                    emit(ParentUpdateProfileImageSuccessState());
                  }).catchError((error) {
                    print('Error: $error');
                    emit(ParentUpdateProfileImageErrorState());
                  });
                })
              })
          .catchError((error) {
        print('Error: $error');
        emit(ParentUpdateProfileImageErrorState());
      });
    } else {
      emit(ParentUpdateProfileImageErrorState());
    }
  }

  void updateChildrenProfile({
    required String id,
    String? name,
    String? education,
    String? phone,
    int? age,
    String? gender,
    String? certificate,
  }) async {
    emit(ParentUpdateProfileLoadingState());
    if (phone != null) {
      final phoneNumbers =
          await FirebaseFirestore.instance.collection('phoneNumbers').get();
      if (checkPhone(phone, phoneNumbers.docs)) {
        emit(ParentUpdateProfileErrorState(
            error: 'This phone number is already in use'));
        return;
      }
      await FirebaseFirestore.instance.collection('phoneNumbers').doc(id).set({
        'phone': phone,
      });
    }
    await FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('children')
        .doc(id)
        .update({
      'name': name,
      'educationLevel': education,
      'phone': phone,
      'age': age,
      'gender': gender,
      'certificate': certificate,
    }).then((value) {
      emit(ParentUpdateProfileSuccessState());
    }).catchError((error) {
      print('Error: $error');
      emit(
        ParentUpdateProfileErrorState(
            error: 'Error: ${error.toString().split(']')[1]}'),
      );
    });
  }

  void sendMessageToTeacher({
    required String message,
    required String receiverId,
    required String schoolId,
    required bool isTeacher,
  }) {
    emit(ParentSendMessageLoadingState());
    MessageModel messageModel = MessageModel(
      senderId: PARENT_MODEL!.id,
      receiverId: receiverId,
      message: message,
      dateTime: DateTime.now().toString(),
      time: DateFormat.jm().format(DateTime.now()),
    );
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Success send message to parent🎉');
    });
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('${isTeacher ? 'teachers' : 'supervisors'}')
        .doc(receiverId)
        .collection('chats')
        .doc(PARENT_MODEL!.id)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Success send message to teacher 🎉');
      emit(ParentSendMessageSuccessState());
    }).catchError((error) {
      print('Error send message: $error');
      emit(ParentSendMessageErrorState(error: error.toString()));
    });
  }

  List<ReportModel> parentReportsList = [];
  void getAllChildReports({required String childId}) {
    emit(ParentGetAllChildReportsLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('children')
        .doc(childId)
        .collection('reports')
        .snapshots()
        .listen((event) {
      parentReportsList = [];
      event.docs.forEach((element) {
        parentReportsList.add(ReportModel.fromJson(element.data()));
      });
      emit(ParentGetAllChildReportsSuccessState());
    });
  }

  List<AttendModel> parentAttendList = [];
  void getAllChildAttend({required String childId}) {
    emit(ParentGetAllChildAttendLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('children')
        .doc(childId)
        .collection('schedules')
        .snapshots()
        .listen((event) {
      parentAttendList = [];
      event.docs.forEach((element) {
        parentAttendList.add(AttendModel.fromJson(element.data()));
      });
      emit(ParentGetAllChildAttendSuccessState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({required String receiverId}) {
    emit(ParentGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(ParentGetMessagesSuccessState());
    });
  }
}
