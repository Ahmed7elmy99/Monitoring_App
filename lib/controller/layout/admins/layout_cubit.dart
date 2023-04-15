import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/const_data.dart';
import '../../../models/admin_models.dart';
import '../../../models/children_model.dart';
import '../../../models/parent_model.dart';
import '../../../models/school_model.dart';
import '../../../models/supervisors_model.dart';
import '../../../models/teacher_model.dart';
import '../../../modules/admin/home/admin_home_screen.dart';
import '../../../modules/admin/settings/admin_settings_screen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static LayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    const AdminHomeScreen(),
    const AdminSettingsScreen(),
  ];
  List titles = [
    'Home',
    'Settings',
  ];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }

  void createAdminAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String isBan,
  }) {
    emit(LayoutCreateAdminAccountLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('Success Create Admin Account🎉');
      print('value: $value');
      if (value.user?.uid != null) {
        addAdminInFirebase(
          adminUid: value.user!.uid,
          adminName: name,
          adminEmail: email,
          adminPassword: password,
          adminPhone: phone,
          adminGen: gender,
          adminIsBan: isBan,
        );
      }
      emit(LayoutCreateAdminAccountSuccessState());
    }).catchError((error) {
      emit(LayoutCreateAdminAccountErrorState(error.toString()));
    });
  }

  void addAdminInFirebase({
    required String adminUid,
    required String adminName,
    required String adminEmail,
    required String adminPassword,
    required String adminPhone,
    required String adminGen,
    required String adminIsBan,
  }) {
    //emit(LayoutAddAdminLoadingState());
    AdminModels adminModels = AdminModels(
      id: adminUid,
      name: adminName,
      email: adminEmail,
      password: adminPassword,
      phone: adminPhone,
      image: AppImages.defaultImage2,
      gender: adminGen,
      createdAt: DateTime.now().toString(),
      ban: adminIsBan,
    );
    FirebaseFirestore.instance
        .collection('admins')
        .doc(adminUid)
        .set(adminModels.toMap())
        .then((value) {
      print('Admin Added Success🎉');
      //emit(LayoutAddAdminSuccessState());
    }).catchError((error) {
      print('Admin Added Error: $error');
      //emit(LayoutAddAdminErrorState(error.toString()));
    });
  }

//i will update this function agein 📌
  Future<void> updateUserData(
      {String? adminName, String? adminPhone, String? adminGen}) async {
    emit(LayoutUpdateUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(ADMIN_MODEL?.id)
        .update({
      'name': adminName == null ? ADMIN_MODEL?.name : adminName,
      'phone': adminPhone == null ? ADMIN_MODEL?.phone : adminPhone,
      'gender': adminGen == null ? ADMIN_MODEL?.gender : adminGen,
    }).then((value) {
      print('Success update user data✨');
      getCurrentAdmin();
      emit(LayoutUpdateUserDataSuccessState());
    }).catchError((error) {
      emit(LayoutUpdateUserDataErrorState(error.toString()));
    });
  }

  XFile? profileImage;
  File? uploadImageFile;
  String? profileImageUrl;
  void getImageFromGallery({required String uid}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      profileImage = image;
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      updateProfileImage(userId: uid);
      emit(LayoutGetImageSuccessState());
    } else {
      print('No image selected.');
      emit(LayoutGetImageErrorState());
    }
  }

  void updateProfileImage({required String userId}) {
    emit(LayoutUpdateUserImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$userId')
        .putFile(uploadImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        uploadImageFile = null;
        FirebaseFirestore.instance
            .collection('admins')
            .doc(ADMIN_MODEL?.id)
            .update({
          'image': profileImageUrl,
        });
        getCurrentAdmin();
        emit(LayoutUpdateUserImageSuccessState());
      }).catchError((error) {
        print('Error get image url: $error');
        emit(LayoutUpdateUserImageErrorState(error.toString()));
      });
    });
  }

  void updateAdminsBan({required String adminId, required String adminBan}) {
    emit(LayoutUpdateAdminsBanLoadingState());
    FirebaseFirestore.instance.collection('admins').doc(adminId).update({
      'ban': adminBan,
    }).then((value) {
      print('Success update admins ban🎉');
      emit(LayoutUpdateAdminsBanSuccessState());
    }).catchError((error) {
      print('Error update admins ban: $error');
      emit(LayoutUpdateAdminsBanErrorState(error.toString()));
    });
  }

  List<AdminModels> adminModelsList = [];
  void getAllAdmins() {
    try {
      emit(LayoutGetAllAdminsLoadingState());
      FirebaseFirestore.instance
          .collection('admins')
          .snapshots()
          .listen((value) {
        adminModelsList = [];
        for (var element in value.docs) {
          if (element.data()['id'] != ADMIN_MODEL!.id) {
            adminModelsList.add(AdminModels.fromJson(element.data()));
          }
        }
        print('Success get all admins🎉');
        emit(LayoutGetAllAdminsSuccessState());
      });
    } catch (error) {
      print('Error get all admins: $error');
      emit(LayoutGetAllAdminsErrorState(error.toString()));
    }
  }

  String? schoolId;
  void addSchoolInFirebase({
    required String schoolName,
    required String schoolDescription,
    required String schoolPhone,
    required String schoolLocation,
    required String establishmentDate,
    required String establishmentType,
    required String schoolWebsite,
  }) {
    emit(LayoutAddSchoolLoadingState());
    SchoolModel schoolModel = SchoolModel(
      id: ADMIN_MODEL!.id,
      description: schoolDescription,
      name: schoolName,
      location: schoolLocation,
      phone: schoolPhone,
      establishedBy: establishmentType,
      establishedIn: establishmentDate,
      website: schoolWebsite,
      image: AppImages.defaultSchool,
      ban: 'false',
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .add(schoolModel.toMap())
        .then((value) {
      schoolId = value.id;
      FirebaseFirestore.instance.collection('schools').doc(value.id).update({
        'id': value.id,
      }).then((event) {
        print('Success add school🎉');

        emit(LayoutAddSchoolSuccessState());
      });
    }).catchError((error) {
      print('Error add school: $error');
      emit(LayoutAddSchoolErrorState(error.toString()));
    });
  }

  void addSchoolSupervisor({
    required String supervisorId,
    required String supervisorName,
    required String supervisorEmail,
    required String supervisorPassword,
    required String supervisorPhone,
  }) {
    emit(LayoutAddSchoolSupervisorLoadingState());
    SupervisorsModel supervisorsModel = SupervisorsModel(
      id: supervisorId,
      schoolsId: schoolId!,
      name: supervisorName,
      phone: supervisorPhone,
      email: supervisorEmail,
      password: supervisorPassword,
      gender: 'male',
      age: '0',
      ban: 'false',
      image: AppImages.defaultImage,
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('supervisors')
        .doc(supervisorId)
        .set(supervisorsModel.toMap())
        .then((value) {
      print('Success add school supervisor🎉');
      emit(LayoutAddSchoolSupervisorSuccessState());
    }).catchError((error) {
      print('Error add school supervisor: $error');
      emit(LayoutAddSchoolSupervisorErrorState(error.toString()));
    });
  }

  void createSuperVisorAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('Success Create supervisor 🎉');
      print('value: $value');
      if (value.user?.uid != null) {
        addSchoolSupervisor(
          supervisorId: value.user!.uid,
          supervisorName: name,
          supervisorEmail: email,
          supervisorPassword: password,
          supervisorPhone: phone,
        );
      }
    }).catchError((error) {
      print('Error create supervisor account: $error');
      emit(LayoutCreateSuperVisorAccountErrorState(error.toString()));
    });
  }

  List<SchoolModel> schoolModelsList = [];
  void getAllSchools() {
    try {
      emit(LayoutGetAllSchoolsLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .snapshots()
          .listen((value) {
        schoolModelsList = [];
        for (var element in value.docs) {
          schoolModelsList.add(SchoolModel.fromJson(element.data()));
        }
        print('Success get all schools🎉');
        emit(LayoutGetAllSchoolsSuccessState());
      });
    } catch (error) {
      print('Error get all schools: $error');
      emit(LayoutGetAllSchoolsErrorState(error.toString()));
    }
  }

  List<SupervisorsModel> supervisorsModelsList = [];
  void getAllSupervisors({required String schoolId}) {
    try {
      emit(LayoutGetAllSupervisorsLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .collection('supervisors')
          .snapshots()
          .listen((value) {
        supervisorsModelsList = [];
        for (var element in value.docs) {
          supervisorsModelsList.add(SupervisorsModel.fromJson(element.data()));
        }
        print('Success get all supervisors🎉');
        emit(LayoutGetAllSupervisorsSuccessState());
      });
    } catch (error) {
      print('Error get all supervisors: $error');
      emit(LayoutGetAllSupervisorsErrorState(error.toString()));
    }
  }

  List<TeacherModel> teachersList = [];
  void getAllTeachers({required String schoolId}) {
    try {
      emit(LayoutGetAllTeachersLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .collection('teachers')
          .snapshots()
          .listen((value) {
        teachersList = [];
        for (var element in value.docs) {
          teachersList.add(TeacherModel.fromJson(element.data()));
        }
        print('Success get all teachers🎉');
        emit(LayoutGetAllTeachersSuccessState());
      });
    } catch (error) {
      print('Error get all teachers: $error');
      emit(LayoutGetAllTeachersErrorState(error: error.toString()));
    }
  }

  List<ChildrenModel> childrenList = [];
  void getAllChildren({required String schoolId}) {
    try {
      emit(LayoutGetAllChildrenLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolId)
          .collection('children')
          .snapshots()
          .listen((value) {
        childrenList = [];
        for (var element in value.docs) {
          childrenList.add(ChildrenModel.fromJson(element.data()));
        }
        print('Success get all children🎉');
        emit(LayoutGetAllChildrenSuccessState());
      });
    } catch (error) {
      print('Error get all children: $error');
      emit(LayoutGetAllChildrenErrorState(error: error.toString()));
    }
  }

  void changeSchoolBan({
    required String schoolId,
    required String schoolBan,
  }) {
    emit(LayoutChangeSchoolBanLoadingState());
    FirebaseFirestore.instance.collection('schools').doc(schoolId).update({
      'ban': schoolBan,
    }).then((value) {
      print('Success update school ban🎉');
      emit(LayoutChangeSchoolBanSuccessState());
    }).catchError((error) {
      print('Error update school ban: $error');
      emit(LayoutChangeSchoolBanErrorState(error.toString()));
    });
  }

  Future<void> getCurrentAdmin() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(CacheHelper.getData(key: 'uid') == null
            ? ''
            : CacheHelper.getData(key: 'uid'))
        .get()
        .then((value) {
      print('Success get current admin🎉');
      ADMIN_MODEL = AdminModels.fromJson(value.data()!);
      emit(AuthGetUserAfterLoginSuccessState());
    }).catchError((error) {
      emit(AuthGetUserAfterLoginErrorState(error.toString()));
    });
  }

  List<ParentModel> parentList = [];
  void getAllParent() {
    emit(AdminGetAllParentLoadingState());
    FirebaseFirestore.instance.collection('parents').get().then((value) {
      parentList = [];
      for (var element in value.docs) {
        parentList.add(ParentModel.fromJson(element.data()));
      }
      print('Success get all parent🎉');
      emit(AdminGetAllParentSuccessState());
    }).catchError((error) {
      emit(AdminGetAllParentErrorState(error: error.toString()));
    });
  }

  void banParent({required String parentId, required String parentBan}) {
    emit(AdminBanParentLoadingState());
    FirebaseFirestore.instance.collection('parents').doc(parentId).update({
      'ban': parentBan,
    }).then((value) {
      print('Success ban parent🎉');
      emit(AdminBanParentSuccessState());
    }).catchError((error) {
      emit(AdminBanParentErrorState(error: error.toString()));
    });
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      CacheHelper.saveData(key: 'user', value: '');
      emit(AuthAdminSignOutSuccessState());
      currentIndex = 0;
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(AuthAdminSignOutErrorState(error.toString()));
    });
  }
}
