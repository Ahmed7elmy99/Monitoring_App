import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../core/services/cache_helper.dart';
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
