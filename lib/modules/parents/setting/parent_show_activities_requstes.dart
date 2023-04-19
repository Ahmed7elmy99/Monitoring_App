import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/activity_join_model.dart';
import '../../widgets/const_widget.dart';

class ParentShowActivitiesRequests extends StatelessWidget {
  const ParentShowActivitiesRequests({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities Requests'),
      ),
      body: Center(
        child: BlocConsumer<ParentCubit, ParentState>(
          listener: (context, state) {},
          builder: (context, state) {
            ParentCubit parentCubit = ParentCubit.get(context);
            return state is ParentGetAllActivitiesRequestsLoadingState
                ? CircularProgressComponent()
                : parentCubit.parentActivityJoinList.isEmpty
                    ? Center(
                        child: Text(
                          'No Requests Found',
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
                              parentCubit.parentActivityJoinList[index];
                          return _buildItemList(context, item);
                        },
                        separatorBuilder: (context, index) => AppSize.sv_10,
                        itemCount: parentCubit.parentActivityJoinList.length,
                      );
          },
        ),
      ),
    );
  }

  Widget _buildItemList(BuildContext context, ActivityJoinModel item) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.24,
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
            Hero(
              tag: item.id,
              child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(AppImages.requestIcon)),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.sh_10,
                  Text(
                    item.activityStatus,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.activityStatus == 'pending'
                          ? Colors.grey
                          : item.activityStatus == 'accepted'
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
