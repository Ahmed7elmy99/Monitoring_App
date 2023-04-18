import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/school_activities_model.dart';
import '../../widgets/const_widget.dart';
import 'school_activities_details_screen.dart';

class SchoolActivitiesScreen extends StatelessWidget {
  const SchoolActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('School Activities'),
        ),
        body: BlocConsumer<SchoolsCubit, SchoolsState>(
          listener: (context, state) {},
          builder: (context, state) {
            SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
            return state is SchoolsGetAllActivitiesLoadingState
                ? CircularProgressComponent()
                : schoolsCubit.schoolsActivitiesList.isEmpty
                    ? Center(
                        child: Text(
                          'No Children Yet',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          SchoolActivitiesModel item =
                              schoolsCubit.schoolsActivitiesList[index];
                          return _buildRequestsItemWidget(context, model: item);
                        },
                        separatorBuilder: (context, index) => AppSize.sv_10,
                        itemCount: schoolsCubit.schoolsActivitiesList.length,
                      );
          },
        ));
  }

  Widget _buildRequestsItemWidget(BuildContext context,
      {required SchoolActivitiesModel model}) {
    return InkWell(
      onTap: () {
        BlocProvider.of<SchoolsCubit>(context)
            .getAllChildrenInActivities(activityId: model.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchoolActivitiesDetailsScreen(
              schoolActivitiesModel: model,
            ),
          ),
        );
      },
      child: Container(
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
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(AppImages.activityIcon01),
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
                  Text(
                    model.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    model.activityType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: model.activityType == 'pending'
                          ? Colors.blue
                          : model.activityType == 'accepted'
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w400,
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
