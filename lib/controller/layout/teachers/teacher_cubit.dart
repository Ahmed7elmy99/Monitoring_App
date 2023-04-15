import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/const_data.dart';
import '../../../models/attend_model.dart';
import '../../../models/children_model.dart';
import '../../../models/class_join_Model.dart';
import '../../../models/class_model.dart';
import '../../../models/message_model.dart';
import '../../../models/parent_model.dart';
import '../../../models/teacher_model.dart';
import '../../../modules/teachers/home/teacher_home_screen.dart';
import '../../../modules/teachers/setting/teacher_setting_screen.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit() : super(TeacherInitial());
  static TeacherCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(TeacherChangeBottomNavState());
  }

  List<Widget> screens = [
    TeacherHomeScreen(),
    TeacherSettingScreen(),
  ];
  List<String> titles = [
    'Home',
    'Setting',
  ];

  void getCurrentTeacher() async {
    await FirebaseFirestore.instance.collection('schools').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('schools')
            .doc(element.id)
            .collection('teachers')
            .doc(CacheHelper.getData(key: 'uid') == null
                ? ''
                : CacheHelper.getData(key: 'uid'))
            .get()
            .then((value) {
          if (value.exists) {
            TEACHER_MODEL = TeacherModel.fromJson(value.data()!);

            emit(TeacherGetCurrentTeacherSuccessState());
          } else {
            emit(TeacherGetCurrentTeacherErrorState());
          }
        });
      });
    });
  }

  List<TeacherModel> teachersList = [];
  void getAllTeacher() {
    try {
      emit(TeacherGetAllTeachersLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(TEACHER_MODEL?.schoolId ?? '')
          .collection('teachers')
          .snapshots()
          .listen((value) {
        teachersList = [];
        for (var element in value.docs) {
          if (element.id == TEACHER_MODEL?.id) {
            print('');
          } else {
            teachersList.add(TeacherModel.fromJson(element.data()));
          }
        }
        print("schoolsTeachersList: 🎉");
        emit(TeacherGetAllTeachersSuccessState());
      });
    } catch (error) {
      print('Error get all teachers: $error');
      emit(TeacherGetAllTeachersErrorState(error: error.toString()));
    }
  }

  List<ClassModel> schoolsClassesList = [];
  void getAllSchoolClasses() {
    try {
      emit(TeacherGetAllClassesLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(TEACHER_MODEL?.schoolId ?? '')
          .collection('classes')
          .snapshots()
          .listen((value) {
        schoolsClassesList = [];
        for (var element in value.docs) {
          print('get all classes🎉');
          schoolsClassesList.add(ClassModel.fromJson(element.data()));
        }
        print('Success get all classes🎉');
        emit(TeacherGetAllClassesSuccessState());
      });
    } catch (error) {
      print('Error get all classes: $error');
      emit(TeacherGetAllClassesErrorState(error: error.toString()));
    }
  }

  List<ClassJoinModel> childrenClassJoin = [];
  void getAllChildrenClass({
    required String classId,
  }) {
    emit(TeacherGetAllChildrenClassLoadingState());
    try {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(TEACHER_MODEL?.schoolId ?? '')
          .collection('classes')
          .doc(classId)
          .collection('children')
          .snapshots()
          .listen((value) {
        childrenClassJoin = [];
        for (var element in value.docs) {
          print('get all children class🎉');
          childrenClassJoin.add(ClassJoinModel.fromJson(element.data()));
        }
        print('Success get all children class🎉');
        emit(TeacherGetAllChildrenClassSuccessState());
      });
    } catch (error) {
      print('Error get all children class: $error');
      emit(TeacherGetAllChildrenClassErrorState(error: error.toString()));
    }
  }

  ChildrenModel? childrenModel;
  ParentModel? parentModel;
  void getChildrenData({required String childrenId}) async {
    emit(TeacherGetChildrenDataLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(TEACHER_MODEL?.schoolId ?? '')
          .collection('children')
          .doc(childrenId)
          .get()
          .then((value) {
        if (value.exists) {
          childrenModel = ChildrenModel.fromJson(value.data()!);
          print('Success get children data🎉');
          FirebaseFirestore.instance
              .collection('parents')
              .doc(value.data()!['parentId'])
              .get()
              .then((value) {
            if (value.exists) {
              parentModel = ParentModel.fromJson(value.data()!);
              print('Success get parent data🎉');
              emit(TeacherGetChildrenDataSuccessState());
            } else {
              emit(
                  TeacherGetChildrenDataErrorState(error: 'Parent not found!'));
            }
          });
        } else {
          emit(TeacherGetChildrenDataErrorState(error: 'Children not found!'));
        }
      });
    } catch (error) {
      print('Error get children data: $error');
      emit(TeacherGetChildrenDataErrorState(error: error.toString()));
    }
  }

  void updateTeacherProfile(
      {String? name,
      String? university,
      String? subject,
      String? phone,
      String? address,
      String? age,
      String? gender}) {
    emit(TeacherUpdateProfileLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(TEACHER_MODEL?.schoolId ?? '')
        .collection('teachers')
        .doc(TEACHER_MODEL?.id ?? '')
        .update({
      'name': name ?? TEACHER_MODEL?.name,
      'university': university ?? TEACHER_MODEL?.university,
      'subject': subject ?? TEACHER_MODEL?.subject,
      'phone': phone ?? TEACHER_MODEL?.phone,
      'address': address ?? TEACHER_MODEL?.address,
      'age': age ?? TEACHER_MODEL?.age,
      'gender': gender ?? TEACHER_MODEL?.gender,
    }).then((value) {
      getCurrentTeacher();
      print('Success update teacher profile🎉');
      emit(TeacherUpdateProfileSuccessState());
    }).catchError((error) {
      print('Error update teacher profile: $error');
      emit(TeacherUpdateProfileErrorState(error: error.toString()));
    });
  }

  String studentStatus = 'attend';
  List<String> statusList = [
    'attend',
    'absent',
    'late',
  ];
  void changeStatus({required String status}) {
    studentStatus = status;
    emit(TeacherChangeStatusState());
  }

  void schedulesAttend({required String date}) async {
    AttendModel attendModel = AttendModel(
      id: '4444444444',
      childId: childrenModel?.id ?? '',
      classId: childrenModel?.classId ?? '',
      teacherId: TEACHER_MODEL?.id ?? '',
      date: date,
      status: studentStatus,
    );
    emit(TeacherSchedulesAttendLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(TEACHER_MODEL?.schoolId ?? '')
        .collection('children')
        .doc(childrenModel?.id ?? '')
        .collection('schedules')
        .add(attendModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(TEACHER_MODEL?.schoolId ?? '')
          .collection('children')
          .doc(childrenModel?.id ?? '')
          .collection('schedules')
          .doc(value.id)
          .update({'id': value.id}).then((value) {
        print('Success schedules attend🎉');
        emit(TeacherSchedulesAttendSuccessState());
      });
      FirebaseFirestore.instance
          .collection('parents')
          .doc(childrenModel?.parentId ?? '')
          .collection('children')
          .doc(childrenModel?.id ?? '')
          .collection('schedules')
          .add(attendModel.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('parents')
            .doc(childrenModel?.parentId ?? '')
            .collection('children')
            .doc(childrenModel?.id ?? '')
            .collection('schedules')
            .doc(value.id)
            .update({'id': value.id});
      });
      FirebaseFirestore.instance
          .collection('tokens')
          .doc(childrenModel?.parentId ?? '')
          .get()
          .then((value) {
        if (value.exists) {
          sendNotificationToParent(value.data()!['token']);
        }
      });
    }).catchError((error) {
      print('Error schedules attend: $error');
      emit(
        TeacherSchedulesAttendErrorState(error: error.toString()),
      );
    });
  }

  Future<void> uploadPdfToFirebase() async {
    emit(TeacherUploadPdfLoadingState());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.first.path!);
      String fileName = result.files.first.name;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('reports/$fileName')
          .putFile(file)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          FirebaseFirestore.instance
              .collection('schools')
              .doc(TEACHER_MODEL?.schoolId ?? '')
              .collection('children')
              .doc(childrenModel!.id)
              .collection('reports')
              .add({
            'id': '',
            'childId': childrenModel!.id,
            'teacherId': TEACHER_MODEL?.id ?? '',
            'file': value,
          }).then((value) {
            FirebaseFirestore.instance
                .collection('schools')
                .doc(TEACHER_MODEL?.schoolId ?? '')
                .collection('children')
                .doc(childrenModel!.id)
                .collection('reports')
                .doc(value.id)
                .update({'id': value.id});
          });
          FirebaseFirestore.instance
              .collection('parents')
              .doc(childrenModel!.parentId)
              .collection('children')
              .doc(childrenModel!.id)
              .collection('reports')
              .add({
            'id': '',
            'childId': childrenModel!.id,
            'teacherId': TEACHER_MODEL?.id ?? '',
            'file': value,
          }).then((value) {
            FirebaseFirestore.instance
                .collection('parents')
                .doc(childrenModel!.parentId)
                .collection('children')
                .doc(childrenModel!.id)
                .collection('reports')
                .doc(value.id)
                .update({'id': value.id});
          });
          emit(TeacherUploadPdfSuccessState());
        });
      }).catchError((error) {
        print('Error upload pdf: $error');
        emit(TeacherUploadPdfErrorState(error: error.toString()));
      });
    }
  }

  void sendMessage({required String message, required String receiverId}) {
    emit(TeacherSendMessageLoadingState());
    MessageModel messageModel = MessageModel(
      senderId: TEACHER_MODEL?.id ?? '',
      receiverId: receiverId,
      message: message,
      dateTime: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(TEACHER_MODEL!.schoolId)
        .collection('teachers')
        .doc(TEACHER_MODEL!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Success send message to teacher 🎉');
      emit(TeacherSendMessageSuccessState());
    }).catchError((error) {
      print('Error send message: $error');
      emit(TeacherSendMessageErrorState(error: error.toString()));
    });
    FirebaseFirestore.instance.collection('parents').doc(receiverId).get().then(
      (value) {
        if (value.exists) {
          FirebaseFirestore.instance
              .collection('parents')
              .doc(receiverId)
              .collection('chats')
              .doc(TEACHER_MODEL!.id)
              .collection('messages')
              .add(messageModel.toMap())
              .then((value) {
            print('Success send message to parent🎉');
          });
        }
      },
    );
  }

  List<MessageModel> messages = [];
  void getMessages({required String receiverId}) {
    emit(TeacherGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(TEACHER_MODEL!.schoolId)
        .collection('teachers')
        .doc(TEACHER_MODEL!.id)
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
      emit(TeacherGetMessagesSuccessState());
    });
  }

  Future<void> signOutTeacher() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      CacheHelper.saveData(key: 'schoolId', value: '');
      CacheHelper.saveData(key: 'user', value: '');
      currentIndex = 0;
      print('Sign Out Success🎉');
      emit(TeacherSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(TeacherSignOutErrorState(error: error.toString()));
    });
  }

  void sendNotificationToParent(String token) {
    var response = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        "content-type": "application/json",
        "Authorization": TOKEN_MESSAGE,
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "body":
              "📌 We have an important update for you! Your child's attendance has just been recorded and we're thrilled to share that they're doing amazing. Log in to the app to see for yourself and keep up the good work!",
          "title": 'Attendance Recorded👨‍🏫',
          "sound": "default",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        }
      }),
    );
  }
}
