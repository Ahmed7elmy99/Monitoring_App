import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/schools/schools_settings_screen.dart';
import '../../../modules/schools/shcools_home_screens.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit() : super(SchoolsInitial());
  static SchoolsCubit get(context) => BlocProvider.of(context);
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  List<Widget> screens = [
    SchoolsHomeScreen(),
    SchoolsSettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Settings',
  ];
  void changeBottomNavBar(int index) {
    _currentIndex = index;
    emit(SchoolsChangeBottomNavBarState());
  }
}
