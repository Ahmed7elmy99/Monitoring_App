import 'package:flutter/material.dart';
import 'package:teatcher_app/modules/admin/settings/add_admin_screen.dart';
import 'package:teatcher_app/modules/admin/settings/add_supervisor_screen.dart';

import '../../modules/admin/admin_layout_screen.dart';
import '../../modules/admin/home/admins/admins_screen.dart';
import '../../modules/admin/home/schools/schools_screen.dart';
import '../../modules/admin/settings/add_school_screen.dart';
import '../../modules/admin/settings/edit_profile_admin.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/auth/register_screen.dart';
import '../../modules/parents/home/parent_schools_screen.dart';
import '../../modules/parents/parents_layout_screen.dart';
import '../../modules/parents/setting/add_children_screen.dart';
import '../../modules/parents/setting/edit_parent_profile.dart';
import '../../modules/schools/home/add_school_supervisor.dart';
import '../../modules/schools/home/school_supervisor_screen.dart';
import '../../modules/schools/home/school_teachers_screen.dart';
import '../../modules/schools/home/show_school_classe_screen.dart';
import '../../modules/schools/setting/create_class_screen.dart';
import '../../modules/schools/setting/create_school_activities_screen.dart';
import '../../modules/schools/setting/create_teacher_screen.dart';
import '../../modules/schools/setting/edit_school_information.dart';
import '../../modules/schools/setting/edit_supervisor_screen.dart';
import '../../modules/schools/supervisors_layout_screen.dart';
import '../../modules/teachers/teacher_layout_screen.dart';

class Routers {
  static const String INITIAL = '/';
  static const String SPLASH_SCREEN = '/splash_screen';
  static const String LOGIN = '/Login_Screen';
  static const String REGISTER_SCREEN = '/Register_Screen';
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
  static const String SCHOOL_SUPERVISOR = '/School_Supervisors_Screen';
  static const String SCHOOL_TEACHERS = '/School_Teachers_Screen';
  static const String SCHOOL_CLASSES = '/School_Classes_Screen';
  static const String ADD_SCHOOL_SUPERVISOR = '/Add_School_Supervisor_Screen';
  static const String CREATE_TEACHER = '/Create_Teacher_Screen';
  static const String CREATE_CLASS = '/Create_Class_Screen';
  static const String CREATE_SCHOOL_ACTIVITIES =
      '/Create_School_Activities_Screen';
  static const String PARENTS_LAYOUT_SCREEN = '/Parents_Layout_Screen';
  static const String PARENTS_EDIT_PROFILE = '/Parents_Edit_Profile_Screen';
  static const String ADD_CHILDREN_SCREEN = '/Add_Children_Screen';
  static const String PARENTS_SCHOOLS_SCREEN = '/Parents_Schools_Screen';
  static const String TEACHERS_LAYOUT_SCREEN = '/Teachers_Layout_Screen';
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
          child: AddSupervisorScreen(),
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
      case Routers.SCHOOL_SUPERVISOR:
        return MaterialPageRoute(
          builder: (_) => const SchoolSupervisorScreen(),
        );
      case Routers.SCHOOL_TEACHERS:
        return MaterialPageRoute(
          builder: (_) => const SchoolTeachersScreen(),
        );
      case Routers.SCHOOL_CLASSES:
        return MaterialPageRoute(
          builder: (_) => const ShowSchoolClassScreen(),
        );
      case Routers.ADD_SCHOOL_SUPERVISOR:
        return MaterialPageRoute(
          builder: (_) => AddSchoolSupervisorScreen(),
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
      case Routers.REGISTER_SCREEN:
        return _buildPageRoute(
          child: RegisterScreen(),
          settings: settings,
        );
      case Routers.PARENTS_LAYOUT_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const ParentsLayoutScreen(),
        );
      case Routers.PARENTS_EDIT_PROFILE:
        return MaterialPageRoute(
          builder: (_) => const EditParentProfileScreen(),
        );
      case Routers.ADD_CHILDREN_SCREEN:
        return MaterialPageRoute(
          builder: (_) => AddChildrenScreen(),
        );
      case Routers.PARENTS_SCHOOLS_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const ParentSchoolsScreen(),
        );
      case Routers.TEACHERS_LAYOUT_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const TeachersLayoutScreen(),
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
