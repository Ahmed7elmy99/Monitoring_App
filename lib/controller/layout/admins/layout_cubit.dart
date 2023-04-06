import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatcher_app/core/services/cache_helper.dart';
import 'package:teatcher_app/core/utils/app_images.dart';

import '../../../core/utils/const_data.dart';
import '../../../models/admin_models.dart';
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

  void userRegister() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: 'Admin912@gmail.com',
      password: 'Admin912',
    )
        .then((value) {
      print('User Register Success');
      print('value: $value');
      print('value.user: ${value.user?.uid}');
    }).catchError((error) {});
  }

  void userLogin() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: 'Admin911@gmail.com',
      password: 'Admin911',
    )
        .then((value) {
      print('User Login Success');
      print('value: $value');
      print('value.user: ${value.user?.uid}');
      CacheHelper.saveData(key: 'uid', value: value.user?.uid);
    }).catchError((error) {});
  }

  Future<void> updateUserData({
    String? adminId,
    String? adminName,
    String? adminEmail,
    String? adminPhone,
    String? adminGen,
    String? adminImage,
  }) async {
    emit(LayoutUpdateUserDataLoadingState());
    AdminModels updateModel = AdminModels(
      id: adminId == null ? ADMIN_MODEL!.id : adminId,
      name: adminName == null ? ADMIN_MODEL!.name : adminName,
      email: adminEmail ?? ADMIN_MODEL!.email,
      password: ADMIN_MODEL!.password,
      createdAt: ADMIN_MODEL!.createdAt,
      image: adminImage == null ? ADMIN_MODEL!.image : adminImage,
      phone: adminPhone == null ? ADMIN_MODEL!.phone : adminPhone,
      gender: adminGen == null ? ADMIN_MODEL!.gender : adminGen,
      ban: ADMIN_MODEL!.ban,
    );
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(adminId == null ? ADMIN_MODEL!.id : adminId)
        .update(updateModel.toMap())
        .then((value) {
      print('Success update user data✨');
      getUserAfterLoginOrRegister();
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
        updateUserData(adminImage: profileImageUrl, adminId: userId);
      }).catchError((error) {
        print('Error get image url: $error');
        emit(LayoutUpdateUserImageErrorState(error.toString()));
      });
    });
  }

  void updateAdminsData(AdminModels adminModels) {
    emit(LayoutUpdateAdminsDataLoadingState());
    FirebaseFirestore.instance
        .collection('admins')
        .doc(adminModels.id)
        .update(adminModels.toMap())
        .then((value) {
      getAllAdmins();
      emit(LayoutUpdateAdminsDataSuccessState());
    }).catchError((error) {
      emit(LayoutUpdateAdminsDataErrorState(error.toString()));
    });
  }

  void updateAdminsImages({required AdminModels userModel}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      profileImage = image;
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${userModel.id}')
          .putFile(uploadImageFile!)
          .then((p0) => {
                p0.ref.getDownloadURL().then((value) {
                  profileImageUrl = value;
                  uploadImageFile = null;
                  userModel.image = value;
                  updateAdminsData(userModel);
                }).catchError((error) {
                  print('Error get image url: $error');
                  emit(LayoutUpdateUserImageErrorState(error.toString()));
                }),
              });
    }
  }

  List<AdminModels> adminModelsList = [];
  void getAllAdmins() {
    emit(LayoutGetAllAdminsLoadingState());
    FirebaseFirestore.instance.collection('admins').get().then((value) {
      adminModelsList = [];
      for (var element in value.docs) {
        if (element.data()['id'] != ADMIN_MODEL!.id) {
          adminModelsList.add(AdminModels.fromJson(element.data()));
        }
      }
      print('Success get all admins🎉');
      emit(LayoutGetAllAdminsSuccessState());
    }).catchError((error) {
      print('Error get all admins: $error');
      emit(LayoutGetAllAdminsErrorState(error.toString()));
    });
  }

  Future<void> getUserAfterLoginOrRegister() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(CacheHelper.getData(key: 'uid'))
        .get()
        .then((value) {
      print('value: ${value.data()}');
      print('Success get user👋');
      ADMIN_MODEL = AdminModels.fromJson(value.data()!);
      emit(AuthGetUserAfterLoginSuccessState());
    }).catchError((error) {
      emit(AuthGetUserAfterLoginErrorState(error.toString()));
    });
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      print('Sign Out Success🎉');
      emit(AuthAdminSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(AuthAdminSignOutErrorState(error.toString()));
    });
  }
}
