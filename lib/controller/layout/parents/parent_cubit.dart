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
import 'package:teatcher_app/models/school_activities_model.dart';
import 'package:teatcher_app/models/teacher_model.dart';
import 'package:teatcher_app/modules/parents/home/parent_home_screen.dart';
import 'package:teatcher_app/modules/parents/parent_setting_screen.dart';

import '../../../core/services/cache_helper.dart';
import '../../../models/parent_model.dart';
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

  void updateParentProfileData({
    String? name,
    String? phone,
    String? age,
    String? gender,
  }) async {
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
      print('Sign Out Success🎉');
      emit(ParentSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(ParentSignOutErrorState());
    });
  }

  void getCurrentParentData() {
    FirebaseFirestore.instance
        .collection('parents')
        .doc(CacheHelper.getData(key: 'uid') == null
            ? ''
            : CacheHelper.getData(key: 'uid'))
        .snapshots()
        .listen((event) {
      PARENT_MODEL = ParentModel.fromJson(event.data()!);
      emit(ParentGetCurrentDataSuccessState());
    });
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
      name: name,
      gender: gender,
      age: age,
      educationLevel: educationLevel,
      certificate: certificate,
      phone: phone,
      image: AppImages.defaultChildren,
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
        parentSchoolsActivityList
            .add(SchoolActivitiesModel.fromJson(element.data()));
      });
      emit(ParentGetAllSchoolsActivitySuccessState());
    });
  }
}
