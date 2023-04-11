import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/services/cache_helper.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit() : super(TeacherInitial());
  static TeacherCubit get(context) => BlocProvider.of(context);
  Future<void> signOutTeacher() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      CacheHelper.saveData(key: 'schoolId', value: '');
      CacheHelper.saveData(key: 'user', value: '');
      print('Sign Out Success🎉');
      emit(TeacherSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(TeacherSignOutErrorState(error: error.toString()));
    });
  }
}
