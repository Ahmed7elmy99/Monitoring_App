import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teatcher_app/core/services/cache_helper.dart';
import 'package:teatcher_app/models/supervisors_model.dart';

import '../../core/utils/const_data.dart';
import '../../models/admin_models.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  void userRegister() {
    emit(AuthCreateAccountLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: 'Admin911@gmail.com',
      password: 'Admin911',
    )
        .then((value) {
      print('User Register Success');
      print('value: $value');
      print('value.user: ${value.user?.uid}');
      emit(AuthCreateAccountSuccessState());
    }).catchError((error) {
      emit(AuthCreateAccountErrorState(error.toString()));
    });
  }

  var userDoc;
  dynamic supervisorsDoc;
  void getUserAfterLoginOrRegister(
      {required String email, required String password}) async {
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
          CacheHelper.saveData(key: 'uid', value: '');
          emit(AuthGetUserAfterLoginErrorState('You are banned 😥'));
          return;
        }
        ADMIN_MODEL = AdminModels.fromJson(userDoc.data()!);
        emit(AuthGetUserAfterLoginSuccessState('admin'));
        break;
      } else if (isSupervisor) {
        userDoc = await supervisorsDoc.get();
        if (userDoc.data()!['ban'] == 'true') {
          print('User is banned 😥');
          FirebaseAuth.instance.signOut();
          CacheHelper.saveData(key: 'uid', value: '');
          emit(AuthGetUserAfterLoginErrorState('You are banned 😥'));
          return;
        }
        SUPERVISOR_MODEL = SupervisorsModel.fromJson(userDoc.data()!);
        emit(AuthGetUserAfterLoginSuccessState('supervisor'));
        break;
      } else {
        print('no user found');
        emit(AuthGetUserAfterLoginErrorState('no user found'));
      }
    }
  }

  // var userDoc;
  // dynamic supervisorsDoc;
  // void _getUserAfterLoginOrRegister({required String? userId}) async {
  //   emit(AuthGetUserAfterLoginLoadingState());
  //   // Query the admins and supervisors collections in Firebase
  //   final adminsDoc =
  //       FirebaseFirestore.instance.collection('admins').doc(userId);
  //   final schoolDocs =
  //       FirebaseFirestore.instance.collection('school').get().then((value) {
  //     value.docs.forEach((element) {
  //       supervisorsDoc = FirebaseFirestore.instance
  //           .collection('school')
  //           .doc(element.id)
  //           .collection('supervisors')
  //           .doc(userId);
  //     });
  //   });
  //   final isAdmin = await adminsDoc.get().then((doc) => doc.exists);
  //   final isSupervisor = await supervisorsDoc.get().then((doc) => doc.exists);
  //   if (isAdmin) {
  //     userDoc = await adminsDoc.get();
  //     print('userDoc: $userDoc  isAdmin: $isAdmin  🎉');
  //   } else if (isSupervisor) {
  //     userDoc = await supervisorsDoc.get();
  //     print('userDoc: $userDoc  isSupervisor: $isSupervisor  🎉');
  //   }
  // await FirebaseFirestore.instance
  //     .collection('admins')
  //     .doc(CacheHelper.getData(key: 'uid'))
  //     .get()
  //     .then((value) {
  //   print('value: $value');
  //   print('value.data(): ${value.data()}');
  //   // chack if user is admin
  //   if (value.data()!['isAdmin'] == 'false') {
  //     print('User is not admin 😥');
  //     FirebaseAuth.instance.signOut();
  //     CacheHelper.saveData(key: 'uid', value: '');
  //     emit(AuthGetUserAfterLoginErrorState('You are not admin 😥'));
  //     return;
  //   }

  //check if user is banned
  //   if (value.data()!['ban'] == 'true') {
  //     print('User is banned 😥');
  //     FirebaseAuth.instance.signOut();
  //     CacheHelper.saveData(key: 'uid', value: '');
  //     emit(AuthGetUserAfterLoginErrorState('Your account is banned 😥'));
  //     return;
  //   } else {
  //     ADMIN_MODEL = AdminModels.fromJson(value.data()!);
  //     emit(AuthGetUserAfterLoginSuccessState());
  //   }
  //   //emit(AuthGetUserAfterLoginSuccessState());
  // }).catchError((error) {
  //   emit(AuthGetUserAfterLoginErrorState(error.toString()));
  // });
  //}
}
