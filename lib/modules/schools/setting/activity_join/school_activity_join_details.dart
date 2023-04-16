import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/activity_join_model.dart';
import '../../../widgets/build_cover_text.dart';
import '../../../widgets/const_widget.dart';
import '../../../widgets/luanch_url.dart';
import '../../../widgets/show_flutter_toast.dart';

class SchoolActivitiesJoinDetailsScreen extends StatelessWidget {
  final ActivityJoinModel activityJoinModel;
  const SchoolActivitiesJoinDetailsScreen(
      {super.key, required this.activityJoinModel});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('School Activities Details'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsAcceptActivitiesJoinRequestSuccessState) {
            showFlutterToast(
              message: 'Success Accept Request Join',
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is SchoolsRejectedActivityRequestSuccessState) {
            showFlutterToast(
              message: 'Success Rejected Request Join',
              toastColor: Colors.red,
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return schoolsCubit.childrenRequestModel == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: schoolsCubit.childrenRequestModel!.id,
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            final Hero toHero = toHeroContext.widget as Hero;
                            return RotationTransition(
                              turns: animation,
                              child: toHero.child,
                            );
                          },
                          child: Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  schoolsCubit.childrenRequestModel!.image),
                            ),
                          ),
                        ),
                        Text(
                          "Name",
                          style: GoogleFonts.almarai(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        AppSize.sv_5,
                        BuildCoverTextWidget(
                            message: schoolsCubit.childrenRequestModel!.name),
                        AppSize.sv_15,
                        Text(
                          "Education Level",
                          style: GoogleFonts.almarai(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        AppSize.sv_5,
                        BuildCoverTextWidget(
                            message: schoolsCubit
                                .childrenRequestModel!.educationLevel),
                        AppSize.sv_15,
                        Text(
                          "Phone",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.almarai(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        AppSize.sv_5,
                        BuildCoverTextWidget(
                            message: schoolsCubit.childrenRequestModel!.phone),
                        AppSize.sv_15,
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age',
                                  style: GoogleFonts.almarai(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                AppSize.sv_5,
                                BuildCoverTextWidget(
                                  message: schoolsCubit
                                      .childrenRequestModel!.age
                                      .toString(),
                                  width: SizeConfig.screenWidth * 0.42,
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: GoogleFonts.almarai(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                AppSize.sv_5,
                                BuildCoverTextWidget(
                                  message:
                                      schoolsCubit.childrenRequestModel!.gender,
                                  width: SizeConfig.screenWidth * 0.42,
                                ),
                              ],
                            ),
                          ],
                        ),
                        AppSize.sv_15,
                        Text(
                          'Certificate',
                          style: GoogleFonts.almarai(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        AppSize.sv_5,
                        Row(
                          children: [
                            BuildCoverTextWidget(
                              message: schoolsCubit
                                  .childrenRequestModel!.certificate,
                              width: SizeConfig.screenWidth * 0.7,
                              maxLines: 1,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                launchURLFunction(schoolsCubit
                                    .childrenRequestModel!.certificate);
                              },
                              icon: const Icon(
                                Icons.open_in_new,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        AppSize.sv_10,
                        state is SchoolsAcceptActivitiesJoinRequestLoadingState ||
                                state
                                    is SchoolsRejectedActivityRequestLoadingState
                            ? CircularProgressComponent()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: Size(
                                          SizeConfig.screenWidth * 0.4,
                                          SizeConfig.screenHeight * 0.06,
                                        ),
                                      ),
                                      onPressed: () {
                                        schoolsCubit
                                            .acceptActivitiesJoinRequest(
                                          activitiesReq: activityJoinModel,
                                        );
                                      },
                                      child: const Text('Accept'),
                                    ),
                                  ),
                                  AppSize.sh_10,
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: Size(
                                          SizeConfig.screenWidth * 0.4,
                                          SizeConfig.screenHeight * 0.06,
                                        ),
                                      ),
                                      onPressed: () {
                                        schoolsCubit.rejectedActivityRequest(
                                          activitiesReq: activityJoinModel,
                                        );
                                      },
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
