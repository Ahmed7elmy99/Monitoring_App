import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teatcher_app/core/services/cache_helper.dart';

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

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AuthUserLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('User Login Success');
      print('value: $value');
      print('value.user: ${value.user?.uid}');
      CacheHelper.saveData(key: 'uid', value: value.user?.uid);
      print(
          'CacheHelper.getData(key: uid): ${CacheHelper.getData(key: 'uid')}');
      _getUserAfterLoginOrRegister();
      emit(AuthUserLoginSuccessState());
    }).catchError((error) {
      emit(AuthUserLoginErrorState(error.toString()));
    });
  }

  void _getUserAfterLoginOrRegister() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(CacheHelper.getData(key: 'uid'))
        .get()
        .then((value) {
      print('value: $value');
      print('value.data(): ${value.data()}');
      //check if user is banned
      if (value.data()!['ban'] == 'true') {
        print('User is banned 😥');
        FirebaseAuth.instance.signOut();
        CacheHelper.saveData(key: 'uid', value: '');
        emit(AuthGetUserAfterLoginErrorState('Your account is banned 😥'));
        return;
      } else {
        ADMIN_MODEL = AdminModels.fromJson(value.data()!);
        emit(AuthGetUserAfterLoginSuccessState());
      }
      //emit(AuthGetUserAfterLoginSuccessState());
    }).catchError((error) {
      emit(AuthGetUserAfterLoginErrorState(error.toString()));
    });
  }
}
