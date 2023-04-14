import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/attend_model.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../core/services/cache_helper.dart';
import '../../../models/children_model.dart';
import '../../../models/class_join_Model.dart';
import '../../../models/class_model.dart';
import '../../../models/parent_model.dart';
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
    }).catchError((error) {
      print('Error schedules attend: $error');
      emit(
        TeacherSchedulesAttendErrorState(error: error.toString()),
      );
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
}
