import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/schools/home/widgets/build_teachers_item.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/teacher_model.dart';
import '../../widgets/const_widget.dart';

class SchoolTeachersScreen extends StatelessWidget {
  const SchoolTeachersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsBanTeacherSuccessState) {}
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllTeachersLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsTeachersList.isEmpty
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
                        TeacherModel item =
                            schoolsCubit.schoolsTeachersList[index];
                        return BuildItemTeachersWidget(model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: schoolsCubit.schoolsTeachersList.length,
                    );
        },
      ),
    );
  }
}
