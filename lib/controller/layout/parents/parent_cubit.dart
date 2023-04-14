import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/children_model.dart';
import 'package:teatcher_app/models/message_model.dart';
import 'package:teatcher_app/models/school_activities_model.dart';
import 'package:teatcher_app/models/teacher_model.dart';
import 'package:teatcher_app/modules/parents/home/parent_home_screen.dart';
import 'package:teatcher_app/modules/parents/parent_setting_screen.dart';

import '../../../core/services/cache_helper.dart';
import '../../../models/activity_join_model.dart';
import '../../../models/parent_model.dart';
import '../../../models/school_join_model.dart';
import '../../../models/school_model.dart';

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

  void updateParentProfileData(
      {String? name, String? phone, String? age, String? gender}) async {
    emit(ParentUpdateProfileImageLoadingState());
    await FirebaseFirestore.instance
        .collection('parents')
        .doc(PARENT_MODEL!.id)
        .update({
      'name': name == null ? PARENT_MODEL!.name : name,
      'phone': phone == null ? PARENT_MODEL!.phone : phone,
      'age': age == null ? PARENT_MODEL!.age : age,
      'gender': gender,
    }).then((value) {
      print('Update parent profile Success🎉');
      emit(ParentUpdateProfileImageSuccessState());
    }).catchError((error) {
      print('Error: $error');
      emit(ParentUpdateProfileImageErrorState());
    });
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
  }) {
    emit(ParentAddChildrenLoadingState());
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

  void crateActivityJoin({
    required String activityId,
    required ChildrenModel childModel,
  }) {
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
          .collection('parents')
          .doc(childModel.parentId)
          .collection('children')
          .doc(childModel.id)
          .update({
        'activityId': 'pending',
      });
      FirebaseFirestore.instance
          .collection('schools')
          .doc(childModel.schoolId)
          .collection('activitiesJoin')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
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
  }) {
    emit(ParentUpdateProfileLoadingState());
    FirebaseFirestore.instance
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
