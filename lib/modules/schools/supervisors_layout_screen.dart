import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/layout/schools/schools_cubit.dart';
import '../../core/style/icon_broken.dart';

class SupervisorLayoutScreen extends StatelessWidget {
  const SupervisorLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SchoolsCubit, SchoolsState>(
      listener: (context, state) {},
      builder: (context, state) {
        SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(schoolsCubit.titles[schoolsCubit.currentIndex]),
          ),
          body: schoolsCubit.screens[schoolsCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: schoolsCubit.currentIndex,
            onTap: (index) {
              schoolsCubit.changeBottomNavBar(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Profile),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
