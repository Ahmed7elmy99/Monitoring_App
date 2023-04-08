import 'package:flutter/material.dart';
import 'package:teatcher_app/modules/admin/settings/add_admin_screen.dart';
import 'package:teatcher_app/modules/admin/settings/add_supervisor_screen.dart';

import '../../modules/admin/admin_layout_screen.dart';
import '../../modules/admin/home/admins/admins_screen.dart';
import '../../modules/admin/home/schools/schools_screen.dart';
import '../../modules/admin/settings/add_school_screen.dart';
import '../../modules/admin/settings/edit_profile_admin.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/schools/setting/create_class_screen.dart';
import '../../modules/schools/setting/create_school_activities_screen.dart';
import '../../modules/schools/setting/create_teacher_screen.dart';
import '../../modules/schools/setting/edit_school_information.dart';
import '../../modules/schools/setting/edit_supervisor_screen.dart';
import '../../modules/schools/supervisors_layout_screen.dart';

class Routers {
  static const String INITIAL = '/';
  static const String SPLASH_SCREEN = '/splash_screen';
  static const String LOGIN = '/Login_Screen';
  static const String REGISTER = '/Register_Screen';
  static const String ADMIN_LAYOUT = '/Admin_Layout_Screen';
  static const String ADMIN_EDIT_PROFILE = '/Admin_Edit_Profile_Screen';
  static const String ADD_ADMIN = '/Add_Admin_Screen';
  static const String ADMINS_SCREEN = '/Admins_Screen';
  static const String SCHOOL = '/School_Screen';
  static const String ADD_SCHOOL = '/Add_School_Screen';
  static const String ADD_SUPERVISOR = '/Add_Supervisor_Screen';
  static const String SUPERVISORS_LAYOUT_SCREEN = '/Supervisors_Layout_Screen';
  static const String SUPERVISORS_EDIT_PROFILE =
      '/Supervisors_Edit_Profile_Screen';
  static const String SCHOOL_EDIT_PROFILE = '/School_Edit_Profile_Screen';
  static const String CREATE_TEACHER = '/Create_Teacher_Screen';
  static const String CREATE_CLASS = '/Create_Class_Screen';
  static const String CREATE_SCHOOL_ACTIVITIES =
      '/Create_School_Activities_Screen';
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
      case Routers.SCHOOL:
        return MaterialPageRoute(
          builder: (_) => const SchoolsScreen(),
        );
      case Routers.ADD_SCHOOL:
        return MaterialPageRoute(
          builder: (_) => AddSchoolScreen(),
        );
      case Routers.ADD_SUPERVISOR:
        return _buildPageRoute(
          child: AddSchoolSupervisorScreen(),
          settings: settings,
        );
      case Routers.SUPERVISORS_LAYOUT_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const SupervisorLayoutScreen(),
        );
      case Routers.SUPERVISORS_EDIT_PROFILE:
        return MaterialPageRoute(
          builder: (_) => const EditSupervisorScreen(),
        );
      case Routers.SCHOOL_EDIT_PROFILE:
        return MaterialPageRoute(
          builder: (_) => const EditSchoolInformation(),
        );
      case Routers.CREATE_TEACHER:
        return MaterialPageRoute(
          builder: (_) => CreateTeacherScreen(),
        );
      case Routers.CREATE_CLASS:
        return MaterialPageRoute(
          builder: (_) => CreateClassScreen(),
        );
      case Routers.CREATE_SCHOOL_ACTIVITIES:
        return MaterialPageRoute(
          builder: (_) => CreateSchoolActivitiesScreen(),
        );
      case Routers.LOGIN:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const AdminLayoutScreen());
    }
  }

  static Route _buildPageRoute(
      {required Widget child, required RouteSettings settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutExpo,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
