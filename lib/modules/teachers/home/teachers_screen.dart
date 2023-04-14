import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/controller/layout/teachers/teacher_cubit.dart';

import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/teacher_model.dart';
import '../../widgets/const_widget.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {},
        builder: (context, state) {
          TeacherCubit teacherCubit = TeacherCubit.get(context);
          return state is TeacherGetAllTeachersLoadingState
              ? CircularProgressComponent()
              : teacherCubit.teachersList.isEmpty
                  ? Center(
                      child: Text(
                        'No Teachers',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        TeacherModel item = teacherCubit.teachersList[index];
                        return _buildItemTeachersWidget(model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: teacherCubit.teachersList.length,
                    );
        },
      ),
    );
  }

  Widget _buildItemTeachersWidget({required TeacherModel model}) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.27,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(model.image),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSize.sv_2,
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 13,
                      color: Colors.teal,
                    ),
                    AppSize.sh_5,
                    Text(
                      model.email,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.subject,
                      size: 13,
                      color: Colors.teal,
                    ),
                    AppSize.sh_5,
                    Expanded(
                      child: Text(
                        model.subject,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
