import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teatcher_app/core/services/cache_helper.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/models/parent_model.dart';

import '../../core/utils/const_data.dart';
import '../../models/admin_models.dart';
import '../../models/supervisors_model.dart';
import '../../models/teacher_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

//
  void userMakLogin({required String email, required String password}) async {
    emit(AuthGetUserAfterLoginLoadingState());
    final auth = FirebaseAuth.instance;
    final userCredential = await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      emit(AuthGetUserAfterLoginErrorState(error: error.toString()));
    });
    CacheHelper.saveData(key: 'uid', value: userCredential.user?.uid);
    final userId = userCredential.user?.uid;
    bool isAdminUser = await isAdmin(userId!);
    bool isParentUser = await isParent(userId);
    bool isTeacherUser = await isTeacher(userId);
    bool isSupervisorUser = await isSupervisor(userId);
    if (isAdminUser == true) {
      emit(AuthGetUserAfterLoginSuccessState(message: 'admin'));
      print('User is an admin😎');
    } else if (isParentUser == true) {
      emit(AuthGetUserAfterLoginSuccessState(message: 'parent'));
      print('User is a parent😎');
    } else if (isTeacherUser == true) {
      emit(AuthGetUserAfterLoginSuccessState(message: 'teacher'));
      print('User is a teacher😎');
    } else if (isSupervisorUser == true) {
      emit(AuthGetUserAfterLoginSuccessState(message: 'supervisor'));
      print('User is a supervisor😎');
    } else {}
  }

  Future<bool> isAdmin(String userId) async {
    final adminRef =
        FirebaseFirestore.instance.collection('admins').doc(userId);
    final adminDocExit = await adminRef.get().then((value) => value.exists);
    final adminDoc = await adminRef.get();
    if (adminDocExit == true) {
      if (adminDoc.data()!['ban'] == 'true') {
        emit(AuthGetUserAfterLoginErrorState(error: 'Admin is banned'));
        return false;
      } else {
        CacheHelper.saveData(key: 'user', value: 'admin');
        ADMIN_MODEL = AdminModels.fromJson(adminDoc.data()!);
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> isParent(String userId) async {
    final parentRef =
        FirebaseFirestore.instance.collection('parents').doc(userId);
    final parentDocExit = await parentRef.get().then((value) => value.exists);
    final parentDoc = await parentRef.get();
    if (parentDocExit == true) {
      if (parentDoc.data()!['ban'] == 'true') {
        emit(AuthGetUserAfterLoginErrorState(error: 'Parent is banned'));
        return false;
      } else {
        CacheHelper.saveData(key: 'user', value: 'parent');
        PARENT_MODEL = ParentModel.fromJson(parentDoc.data()!);
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> isTeacher(String userId) async {
    final schoolsRef = FirebaseFirestore.instance.collection('schools');
    final schoolsQuerySnapshot = await schoolsRef.get();

    for (final schoolDoc in schoolsQuerySnapshot.docs) {
      final String ban = schoolDoc.data()['ban'];
      if (ban == 'true') {
        emit(AuthGetUserAfterLoginErrorState(error: 'School is banned'));
        break;
      }
      final teacherRef = schoolDoc.reference.collection('teachers').doc(userId);
      final teacherDocExit =
          await teacherRef.get().then((value) => value.exists);
      final teacherDoc = await teacherRef.get();
      if (teacherDocExit == true) {
        if (teacherDoc.data()!['ban'] == 'true') {
          emit(AuthGetUserAfterLoginErrorState(error: 'Teacher is banned'));
          return false;
        } else {
          CacheHelper.saveData(key: 'user', value: 'teacher');
          TEACHER_MODEL = TeacherModel.fromJson(teacherDoc.data()!);
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> isSupervisor(String userId) async {
    final schoolsRef = FirebaseFirestore.instance.collection('schools');
    final schoolsQuerySnapshot = await schoolsRef.get();
    for (final schoolDoc in schoolsQuerySnapshot.docs) {
      final ban = schoolDoc.data()['ban'];
      if (ban == 'true') {
        emit(AuthGetUserAfterLoginErrorState(error: 'School is banned'));
        break;
      }
      final supervisorRef =
          schoolDoc.reference.collection('supervisors').doc(userId);
      final supervisorDocExit =
          await supervisorRef.get().then((value) => value.exists);
      final supervisorDoc = await supervisorRef.get();
      if (supervisorDocExit == true) {
        if (supervisorDoc.data()!['ban'] == 'true') {
          emit(AuthGetUserAfterLoginErrorState(error: 'Supervisor is banned'));
          return false;
        } else {
          CacheHelper.saveData(
              key: 'schoolId', value: '${supervisorDoc.data()!['schoolsId']}');
          CacheHelper.saveData(key: 'user', value: 'supervisor');
          SUPERVISOR_MODEL = SupervisorsModel.fromJson(supervisorDoc.data()!);
          return true;
        }
      }
    }
    return false;
  }

  void registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
  }) {
    emit(AuthRegisterUserLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      CacheHelper.saveData(key: 'uid', value: value.user!.uid);
      CacheHelper.saveData(key: 'user', value: 'parent');
      ParentModel parentModel = ParentModel(
        id: value.user!.uid,
        name: name,
        email: email,
        password: password,
        gender: gender,
        age: '',
        phone: phone,
        image: AppImages.defaultImage2,
        ban: 'false',
        createdAt: DateTime.now().toString(),
      );
      FirebaseFirestore.instance
          .collection('parents')
          .doc(value.user?.uid)
          .set(parentModel.toMap())
          .then((value) {
        PARENT_MODEL = ParentModel.fromJson(parentModel.toMap());
        print('User Register Success 😎');
        emit(AuthRegisterUserSuccessState());
      }).catchError((error) {
        print('Error: $error');
        emit(AuthRegisterUserErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(AuthRegisterUserErrorState(error.toString()));
    });
  }
}
