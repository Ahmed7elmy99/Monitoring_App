import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/class_model.dart';
import 'widgets/build_classes_item.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/const_widget.dart';

class ShowSchoolClassScreen extends StatelessWidget {
  const ShowSchoolClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsBanTeacherSuccessState) {}
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllTeachersLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsClassesList.isEmpty
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
                            schoolsCubit.schoolsClassesList[index];
                        return BuildItemClassesWidget(model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: schoolsCubit.schoolsClassesList.length,
                    );
        },
      ),
    );
  }
}
