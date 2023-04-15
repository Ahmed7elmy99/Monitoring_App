import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/school_join_model.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/const_widget.dart';

class ParentShowRequestsScreen extends StatelessWidget {
  const ParentShowRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Requests'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return state is ParentGetAllChildrenLoadingState
              ? CircularProgressComponent()
              : parentCubit.parentSchoolRequestsList.isEmpty
                  ? Center(
                      child: Text(
                        'No Requests',
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
                            parentCubit.parentSchoolRequestsList[index];
                        return _buildItemList(context, item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: parentCubit.parentSchoolRequestsList.length,
                    );
        },
      ),
    );
  }

  Widget _buildItemList(BuildContext context, SchoolRequestModel item) {
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
                    item.requestStatus,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.requestStatus == 'pending'
                          ? Colors.grey
                          : item.requestStatus == 'accepted'
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
