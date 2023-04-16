import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/activity_join_model.dart';
import '../../../widgets/const_widget.dart';
import '../../../widgets/show_flutter_toast.dart';
import 'school_activity_join_details.dart';

class SchoolActivitiesJoinScreen extends StatelessWidget {
  const SchoolActivitiesJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('School Activities Join'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsGetAllActivitiesJoinRequestsSuccessState) {}
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllActivitiesJoinRequestsLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsActivitiesJoinList.isEmpty
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
                        ActivityJoinModel item =
                            schoolsCubit.schoolsActivitiesJoinList[index];
                        return _buildRequestsItemWidget(context, model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: schoolsCubit.schoolsActivitiesJoinList.length,
                    );
        },
      ),
    );
  }

  Widget _buildRequestsItemWidget(BuildContext context,
      {required ActivityJoinModel model}) {
    return InkWell(
      onTap: () {
        if (model.activityStatus == 'pending') {
          BlocProvider.of<SchoolsCubit>(context)
              .getChildForRequest(childId: model.childId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchoolActivitiesJoinDetailsScreen(
                activityJoinModel: model,
              ),
            ),
          );
        } else {
          showFlutterToast(
            message: 'This Request is ${model.activityStatus}',
            toastColor: Colors.red,
          );
        }
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
              backgroundImage: AssetImage(AppImages.activityIcon01),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.id,
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
                      Text(
                        'Request Status: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        model.activityStatus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: model.activityStatus == 'pending'
                              ? Colors.grey
                              : model.activityStatus == 'accepted'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
