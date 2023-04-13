import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/layout/teachers/teacher_cubit.dart';
import '../../core/style/icon_broken.dart';

class TeachersLayoutScreen extends StatelessWidget {
  const TeachersLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {},
      builder: (context, state) {
        TeacherCubit teacherCubit = TeacherCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('${teacherCubit.titles[teacherCubit.currentIndex]}'),
            ),
            body: teacherCubit.screens[teacherCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: teacherCubit.currentIndex,
              onTap: (index) {
                teacherCubit.changeBottomNav(index);
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),
                  label: 'Setting',
                ),
              ],
            ));
      },
    );
  }
}
