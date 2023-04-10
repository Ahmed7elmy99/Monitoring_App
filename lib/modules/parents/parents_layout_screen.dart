import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/layout/parents/parent_cubit.dart';
import '../../core/style/icon_broken.dart';

class ParentsLayoutScreen extends StatelessWidget {
  const ParentsLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentState>(
      listener: (context, state) {},
      builder: (context, state) {
        ParentCubit parentCubit = ParentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(parentCubit.titles[parentCubit.currentIndex]),
          ),
          body: parentCubit.screens[parentCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: parentCubit.currentIndex,
            onTap: (index) {
              parentCubit.changeBottomNav(index);
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
