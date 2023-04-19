import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controller/auth/auth_cubit.dart';
import 'controller/layout/admins/layout_cubit.dart';
import 'controller/layout/parents/parent_cubit.dart';
import 'controller/layout/schools/schools_cubit.dart';
import 'controller/layout/teachers/teacher_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/services/cache_helper.dart';
import 'core/style/theme.dart';
import 'modules/admin/admin_layout_screen.dart';
import 'modules/auth/login_screen.dart';
import 'modules/parents/parents_layout_screen.dart';
import 'modules/schools/supervisors_layout_screen.dart';
import 'modules/teachers/teacher_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(startWidget: checkUser()));
}

Widget checkUser() {
  String user = CacheHelper.getData(key: 'user') ?? '';
  if (user == 'supervisor') {
    return SupervisorLayoutScreen();
  } else if (user == 'admin') {
    return const AdminLayoutScreen();
  } else if (user == 'parent') {
    return ParentsLayoutScreen();
  } else if (user == 'teacher') {
    return const TeachersLayoutScreen();
  } else if (user == '') {
    return LoginScreen();
  } else {
    return LoginScreen();
  }
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({
    super.key,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => LayoutCubit()
            ..getCurrentAdmin()
            ..getAllSchools(),
        ),
        BlocProvider(
          create: (context) => ParentCubit()..getCurrentParentData(),
        ),
        BlocProvider(
            create: (context) => SchoolsCubit()
              ..getCurrentSupervisor()
              ..getCurrentSchool()),
        BlocProvider(
          create: (context) => TeacherCubit()..getCurrentTeacher(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        onGenerateRoute: RoutersGenerated.onGenerateRoute,
        initialRoute: Routers.INITIAL,
        home: startWidget,
      ),
    );
  }
}
