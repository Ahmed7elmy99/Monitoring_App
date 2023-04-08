import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_images.dart';
import '../../../models/class_model.dart';
import '../../../models/school_model.dart';
import '../../../models/supervisors_model.dart';
import '../../../modules/schools/setting/super_setting_screen.dart';
import '../../../modules/schools/shcools_home_screens.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit() : super(SchoolsInitial());
  static SchoolsCubit get(context) => BlocProvider.of(context);
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  List<Widget> screens = [
    SchoolsHomeScreen(),
    SupervisorSettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Settings',
  ];
  void changeBottomNavBar(int index) {
    _currentIndex = index;
    emit(SchoolsChangeBottomNavBarState());
  }

  void getCurrentSupervisor() async {
    await FirebaseFirestore.instance.collection('schools').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('schools')
            .doc(element.id)
            .collection('supervisors')
            .doc(CacheHelper.getData(key: 'uid') == null
                ? ''
                : CacheHelper.getData(key: 'uid'))
            .get()
            .then((value) {
          if (value.exists) {
            SUPERVISOR_MODEL = SupervisorsModel.fromJson(value.data()!);
            emit(SchoolsGetSupervisorSuccessState());
          } else {
            emit(SchoolsGetSupervisorErrorState());
          }
        });
      });
    });
  }

  void getCurrentSchool() async {
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(
          CacheHelper.getData(key: 'schoolId') == null
              ? ''
              : CacheHelper.getData(key: 'schoolId'),
        )
        .get()
        .then((value) {
      if (value.exists) {
        print("School name is: ${value.data()!['name']}");
        SCHOOL_MODEL = SchoolModel.fromJson(value.data()!);
        emit(SchoolsGetSupervisorSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void updateSchoolProfile({
    String? name,
    String? description,
    String? address,
    String? phone,
    String? establishmentDate,
    String? establishmentBy,
    String? website,
  }) async {
    emit(SchoolsUpdateProfileLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .update({
      'name': name == null ? SCHOOL_MODEL?.name : name,
      'description':
          description == null ? SCHOOL_MODEL?.description : description,
      'location': address == null ? SCHOOL_MODEL?.location : address,
      'phone': phone == null ? SCHOOL_MODEL?.phone : phone,
      'establishedIn': establishmentDate == null
          ? SCHOOL_MODEL?.establishedIn
          : establishmentDate,
      'establishedBy': establishmentBy == null
          ? SCHOOL_MODEL?.establishedBy
          : establishmentBy,
      'website': website == null ? SCHOOL_MODEL?.website : website,
    }).then((value) {
      getCurrentSchool();
      emit(SchoolsUpdateProfileSuccessState());
    }).catchError((error) {
      emit(SchoolsUpdateProfileErrorState());
    });
  }

  File? uploadImageFile;
  String? profileImageUrl;
  void getImageFromGallery({required String uid}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$uid')
          .putFile(uploadImageFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          uploadImageFile = null;
          FirebaseFirestore.instance
              .collection('schools')
              .doc(SCHOOL_MODEL?.id)
              .update({
            'image': value,
          }).then((value) {
            getCurrentSchool();
            emit(SchoolsUpdateProfileImageSuccessState());
          }).catchError((error) {
            emit(SchoolsUpdateProfileImageErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SchoolsUpdateProfileImageErrorState(error.toString()));
        });
      });
    } else {
      emit(SchoolsUpdateProfileImageErrorState(
          'No image selected. Please select an image.'));
    }
  }

  void updateSupervisorImage({required String uid}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$uid')
          .putFile(uploadImageFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          uploadImageFile = null;
          FirebaseFirestore.instance
              .collection('schools')
              .doc(SCHOOL_MODEL?.id)
              .collection('supervisors')
              .doc(uid)
              .update({
            'image': value,
          }).then((value) {
            getCurrentSupervisor();
            emit(SchoolsUpdateSupervisorImageSuccessState());
          }).catchError((error) {
            print(error.toString());
            emit(SchoolsUpdateSupervisorImageErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SchoolsUpdateSupervisorImageErrorState(error.toString()));
        });
      });
    }
  }

  void updateSupervisorProfile({
    String? superName,
    String? superPhone,
    String? superAge,
    String? superGender,
  }) {
    emit(SchoolsUpdateSupervisorProfileLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('supervisors')
        .doc(SUPERVISOR_MODEL?.id)
        .update({
      'name': superName == null ? SUPERVISOR_MODEL?.name : superName,
      'phone': superPhone == null ? SUPERVISOR_MODEL?.phone : superPhone,
      'age': superAge == null ? SUPERVISOR_MODEL?.age : superAge,
      'gender': superGender == null ? SUPERVISOR_MODEL?.gender : superGender,
    }).then((value) {
      getCurrentSupervisor();
      emit(SchoolsUpdateSupervisorProfileSuccessState());
    }).catchError((error) {
      emit(SchoolsUpdateSupervisorProfileErrorState(error.toString()));
    });
  }

  void createTeacherAccount({
    required String name,
    required String email,
    required String password,
    required String university,
    required String phone,
    required String address,
    required String age,
    required String gender,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.uid);
      if (value.user?.uid != null) {
        addTeacher(
          teachId: value.user!.uid,
          teachName: name,
          teachEmail: email,
          teachPassword: password,
          teachUniversity: university,
          teachPhone: phone,
          teachAddress: address,
          teachAge: age,
          teachGender: gender,
        );
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void addTeacher({
    required String teachId,
    required String teachName,
    required String teachEmail,
    required String teachPassword,
    required String teachUniversity,
    required String teachPhone,
    required String teachAddress,
    required String teachAge,
    required String teachGender,
  }) {
    emit(SchoolsAddTeacherLoadingState());
    TeacherModel teacherModel = TeacherModel(
      id: teachId,
      schoolId: SCHOOL_MODEL!.id,
      name: teachName,
      email: teachEmail,
      password: teachPassword,
      university: teachUniversity,
      subject: '',
      image: AppImages.defaultImage2,
      phone: teachPhone,
      gender: teachGender,
      age: teachAge,
      address: teachAddress,
      ban: 'false',
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('teachers')
        .doc(teachId)
        .set(teacherModel.toMap())
        .then((value) {
      emit(SchoolsAddTeacherSuccessState());
    }).catchError((error) {
      emit(SchoolsAddTeacherErrorState(error.toString()));
    });
  }

  void createClass({required String className, required String eduLevel}) {
    emit(SchoolsAddClassLoadingState());
    ClassModel classModel = ClassModel(
      id: SUPERVISOR_MODEL!.id,
      name: className,
      schoolId: SCHOOL_MODEL!.id,
      educationalLevel: eduLevel,
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('classes')
        .add(classModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('classes')
          .doc(value.id)
          .update({
            'id': value.id,
          })
          .then((value) {})
          .catchError((error) {
            emit(SchoolsAddClassErrorState(error.toString()));
          });
      emit(SchoolsAddClassSuccessState());
    }).catchError((error) {
      emit(SchoolsAddClassErrorState(error.toString()));
    });
  }
}
