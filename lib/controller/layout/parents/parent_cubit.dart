import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/parents/parent_home_screen.dart';
import 'package:teatcher_app/modules/parents/parent_setting_screen.dart';

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
}
