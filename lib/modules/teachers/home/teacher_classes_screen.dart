import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/class_model.dart';
import '../../widgets/const_widget.dart';
import 'teacher_classes_details_screen.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          TeacherCubit teacherCubit = TeacherCubit.get(context);
          return state is TeacherGetAllClassesLoadingState
              ? CircularProgressComponent()
              : teacherCubit.schoolsClassesList.isEmpty
                  ? Center(
                      child: Text(
                        'No Classes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        ClassModel item =
                            teacherCubit.schoolsClassesList[index];
                        return _buildItemClassesWidget(context, model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: teacherCubit.schoolsClassesList.length,
                    );
        },
      ),
    );
  }

  Widget _buildItemClassesWidget(BuildContext context,
      {required ClassModel model}) {
    return InkWell(
      onTap: () {
        BlocProvider.of<TeacherCubit>(context)
            .getAllChildrenClass(classId: model.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TeacherClassesDetailsScreen(classModel: model),
          ),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.20,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('${AppImages.classroomIcon2}'),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.educationalLevel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
