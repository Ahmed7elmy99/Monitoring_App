import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/models/school_activities_model.dart';
import 'package:teatcher_app/modules/parents/home/schools/parent_school_request_screen.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/style/icon_broken.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_model.dart';
import '../../../../models/teacher_model.dart';
import '../../../widgets/build_cover_text.dart';
import '../../../widgets/luanch_url.dart';

class ParentSchoolsDetailsScreen extends StatelessWidget {
  final SchoolModel schoolModel;
  const ParentSchoolsDetailsScreen({super.key, required this.schoolModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schools Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              IconBroken.Chat,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: schoolModel.id,
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
                        backgroundImage: NetworkImage(schoolModel.image),
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
                  BuildCoverTextWidget(message: schoolModel.name),
                  AppSize.sv_15,
                  Text(
                    "Description",
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: schoolModel.description),
                  AppSize.sv_15,
                  Text(
                    "Established",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: schoolModel.establishedIn),
                  AppSize.sv_15,
                  Text(
                    "Established By",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: schoolModel.establishedBy),
                  AppSize.sv_15,
                  Text(
                    "Location",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: schoolModel.location),
                  AppSize.sv_15,
                  Text(
                    'phone',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_15,
                  BuildCoverTextWidget(message: schoolModel.phone),
                  AppSize.sv_15,
                  Text(
                    'School Website',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      BuildCoverTextWidget(
                        message: schoolModel.website,
                        width: SizeConfig.screenWidth * 0.7,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          launchURLFunction(schoolModel.website);
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  AppSize.sv_15,
                  Text(
                    'Teachers',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_10,
                  parentCubit.parentSchoolsTeachersList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                parentCubit.parentSchoolsTeachersList.length,
                            itemBuilder: (context, index) {
                              TeacherModel model =
                                  parentCubit.parentSchoolsTeachersList[index];
                              return _buildTeacherCard(context, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Teachers',
                            style: GoogleFonts.almarai(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                  AppSize.sv_15,
                  Text(
                    'Activities',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_10,
                  parentCubit.parentSchoolsActivityList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.11,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                parentCubit.parentSchoolsActivityList.length,
                            itemBuilder: (context, index) {
                              SchoolActivitiesModel model =
                                  parentCubit.parentSchoolsActivityList[index];
                              return _buildActivityCard(context, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Activities',
                            style: GoogleFonts.almarai(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BlocProvider.of<ParentCubit>(context).getAllChildren();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ParentSchoolRequestScreen(
                schoolId: schoolModel.id,
              ),
            ),
          );
        },
        label: const Text('Join'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal.shade400,
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, TeacherModel teacherModel) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routers.PARENTS_SCHOOL_TEACHERS_SCREEN,
          arguments: teacherModel,
        );
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.27,
        margin: const EdgeInsets.only(right: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(teacherModel.image),
            ),
            AppSize.sv_5,
            Text(
              teacherModel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.almarai(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, SchoolActivitiesModel model) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ParentCubit>(context).getAllChildren();
        Navigator.pushNamed(
          context,
          Routers.PARENTS_SCHOOL_ACTIVITY_JOIN_SCREEN,
          arguments: model,
        );
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.65,
        height: SizeConfig.screenHeight * 0.15,
        margin: const EdgeInsets.only(right: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(AppImages.activityIcon02),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    model.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: model.activityType == 'pending'
                            ? Colors.yellow
                            : model.activityType == 'accepted'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    child: Text(
                      model.activityType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.almarai(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: model.activityType == 'pending'
                            ? Colors.yellow
                            : model.activityType == 'accepted'
                                ? Colors.green
                                : Colors.red,
                      ),
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
