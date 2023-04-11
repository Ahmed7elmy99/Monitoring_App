import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/layout/teachers/teacher_cubit.dart';

class TeachersLayoutScreen extends StatelessWidget {
  const TeachersLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers Layout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<TeacherCubit>(context).signOutTeacher();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Teachers Layout'),
      ),
    );
  }
}
