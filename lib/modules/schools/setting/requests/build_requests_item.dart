import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_join_model.dart';
import '../../../widgets/show_flutter_toast.dart';
import 'school_show_details_request.dart';

class BuildRequestsItemWidget extends StatelessWidget {
  final SchoolRequestModel model;
  const BuildRequestsItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<SchoolsCubit, SchoolsState>(
      listener: (context, state) {
        if (state is SchoolsAccepteRequestSuccessState) {
          showFlutterToast(
            message: 'Request Accepted',
            toastColor: Colors.green,
          );
        }
      },
      builder: (context, state) {
        SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
        return InkWell(
          onTap: () {
            if (model.requestStatus == 'accepted') return;
            schoolsCubit.getChildForRequest(childId: model.childId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: schoolsCubit,
                  child: SchoolShowDetailsRequestScreen(requestModel: model),
                ),
              ),
            );
          },
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth * 0.27,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                  backgroundImage: AssetImage(AppImages.requestIcon),
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
                            model.requestStatus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: model.requestStatus == 'pending'
                                  ? Colors.grey
                                  : model.requestStatus == 'accepted'
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
      },
    );
  }
}
