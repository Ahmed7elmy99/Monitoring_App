import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/schools/home/widgets/build_requests_item.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../models/school_join_model.dart';
import '../../widgets/const_widget.dart';

class SchoolRequestsScreen extends StatelessWidget {
  const SchoolRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsBanTeacherSuccessState) {}
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllTeachersLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsRequestsList.isEmpty
                  ? Center(
                      child: Text(
                        'No Requests Yet',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        SchoolRequestModel item =
                            schoolsCubit.schoolsRequestsList[index];
                        return BuildRequestsItemWidget(model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: schoolsCubit.schoolsRequestsList.length,
                    );
        },
      ),
    );
  }
}
