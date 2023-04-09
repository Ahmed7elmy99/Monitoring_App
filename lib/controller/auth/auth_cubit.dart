import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teatcher_app/core/services/cache_helper.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/models/parent_model.dart';
import 'package:teatcher_app/models/supervisors_model.dart';

import '../../core/utils/const_data.dart';
import '../../models/admin_models.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  var userDoc;
  dynamic supervisorsDoc;
  void userLogin({required String email, required String password}) async {
    emit(AuthGetUserAfterLoginLoadingState());
    final auth = FirebaseAuth.instance;
    final userCredential = await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      emit(AuthGetUserAfterLoginErrorState(error.toString()));
    });

// Get the user ID
    CacheHelper.saveData(key: 'uid', value: userCredential.user?.uid);
    final userId = userCredential.user?.uid;
    // Query the admins and supervisors collections in Firebase
    final adminsDoc =
        FirebaseFirestore.instance.collection('admins').doc(userId);
    final schoolDocs =
        await FirebaseFirestore.instance.collection('schools').get();

    // Find the supervisorsDoc for the user's school
    for (var schoolDoc in schoolDocs.docs) {
      supervisorsDoc = FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolDoc.id)
          .collection('supervisors')
          .doc(userId);
      // Check if the user belongs to the admins or supervisors collection
      final isAdmin = await adminsDoc.get().then((doc) => doc.exists);
      final isSupervisor = await supervisorsDoc.get().then((doc) => doc.exists);

      // Get the user's document if it exists in the admins or supervisors collection
      if (isAdmin) {
        userDoc = await adminsDoc.get();
        if (userDoc.data()!['ban'] == 'true') {
          print('User is banned 😥');
          FirebaseAuth.instance.signOut();

          emit(AuthGetUserAfterLoginErrorState('You are banned 😥'));
          return;
        }
        CacheHelper.saveData(key: 'user', value: 'admin');
        ADMIN_MODEL = AdminModels.fromJson(userDoc.data()!);
        emit(AuthGetUserAfterLoginSuccessState('admin'));
        break;
      } else if (isSupervisor) {
        print('schoolDoc.id: ${schoolDoc.id}😅😥');
        CacheHelper.saveData(key: 'schoolId', value: '${schoolDoc.id}');
        userDoc = await supervisorsDoc.get();
        if (userDoc.data()!['ban'] == 'true') {
          print('User is banned 😥');
          FirebaseAuth.instance.signOut();
          CacheHelper.saveData(key: 'uid', value: '');
          CacheHelper.saveData(key: 'user', value: '');
          emit(AuthGetUserAfterLoginErrorState('You are banned 😥'));
          return;
        }
        CacheHelper.saveData(key: 'user', value: 'supervisor');
        SUPERVISOR_MODEL = SupervisorsModel.fromJson(userDoc.data()!);
        print('SUPERVISOR_MODEL: $SUPERVISOR_MODEL');
        print('SUPERVISOR_MODEL: ${SUPERVISOR_MODEL?.schoolsId} 🎉');
        emit(AuthGetUserAfterLoginSuccessState('supervisor'));
        break;
      }
    }
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
