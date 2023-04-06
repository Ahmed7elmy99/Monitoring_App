import 'package:flutter/material.dart';
import 'package:teatcher_app/modules/admin/home/admin_details.dart';
import 'package:teatcher_app/modules/admin/home/schools_screen.dart';
import 'package:teatcher_app/modules/admin/settings/add_admin_screen.dart';

import '../../modules/admin/admin_layout_screen.dart';
import '../../modules/admin/home/admins_screen.dart';
import '../../modules/admin/home/teachers_screen.dart';
import '../../modules/admin/settings/edit_profile_admin.dart';
import '../../modules/auth/login_screen.dart';

class Routers {
  static const String INITIAL = '/';
  static const String SPLASH_SCREEN = '/splash_screen';
  static const String LOGIN = '/Login_Screen';
  static const String REGISTER = '/Register_Screen';
  static const String ADMIN_LAYOUT = '/Admin_Layout_Screen';
  static const String ADMIN_EDIT_PROFILE = '/Admin_Edit_Profile_Screen';
  static const String ADD_ADMIN = '/Add_Admin_Screen';
  static const String ADMINS_SCREEN = '/Admins_Screen';
  static const String ADMIN_DETAILS_SCREEN = '/Admin_Details_Screen';
  static const String SCHOOL = '/School_Screen';
  static const String TEACHER = '/Teacher_Screen';
}

class RoutersGenerated {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routers.ADMIN_LAYOUT:
        return MaterialPageRoute(
          builder: (_) => const AdminLayoutScreen(),
        );
      case Routers.ADMIN_EDIT_PROFILE:
        return MaterialPageRoute(
          builder: (_) => const EditAdminProfileScreen(),
        );
      case Routers.ADD_ADMIN:
        return MaterialPageRoute(
          builder: (_) => AddAdminScreen(),
        );
      case Routers.ADMINS_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const AdminsScreen(),
          settings: settings,
        );
      case Routers.ADMIN_DETAILS_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const AdminDetailsScreen(),
          settings: settings,
        );
      case Routers.SCHOOL:
        return MaterialPageRoute(
          builder: (_) => const SchoolsScreen(),
        );
      case Routers.TEACHER:
        return MaterialPageRoute(
          builder: (_) => const TeachersScreen(),
        );
      case Routers.LOGIN:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const AdminLayoutScreen());
    }
  }
}
