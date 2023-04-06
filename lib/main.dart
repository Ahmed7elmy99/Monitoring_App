import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/controller/auth/auth_cubit.dart';
import 'package:teatcher_app/controller/layout/layout_cubit.dart';
import 'package:teatcher_app/core/style/theme.dart';

import 'core/routes/app_routes.dart';
import 'core/services/cache_helper.dart';
import 'modules/screens/auth/login_screen.dart';
import 'modules/screens/layout/admin/admin_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  runApp(MyApp(startWidget: checkUser()));
}

Widget checkUser() {
  String user = CacheHelper.getData(key: 'uid') ?? '';
  if (user == '') {
    return LoginScreen();
  } else {
    return const AdminLayoutScreen();
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
          create: (context) => LayoutCubit()
            ..getUserAfterLoginOrRegister()
            ..getAllAdmins(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
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
