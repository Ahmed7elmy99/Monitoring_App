import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/activity_join_model.dart';
import '../../../models/school_activities_model.dart';
import '../../widgets/build_cover_text.dart';
import 'school_acctivities_child_detailes.dart';

class SchoolActivitiesDetailsScreen extends StatelessWidget {
  final SchoolActivitiesModel schoolActivitiesModel;
  const SchoolActivitiesDetailsScreen(
      {super.key, required this.schoolActivitiesModel});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Activities Details'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {},
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: schoolActivitiesModel.id,
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
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage(AppImages.activityIcon01),
                      ),
                    ),
                  ),
                  AppSize.sv_20,
                  AppSize.sv_10,
                  Text(
                    "Name",
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: schoolActivitiesModel.name),
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
                  BuildCoverTextWidget(
                      message: schoolActivitiesModel.description),
                  AppSize.sv_15,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: GoogleFonts.almarai(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          AppSize.sv_5,
                          BuildCoverTextWidget(
                            message: schoolActivitiesModel.price,
                            width: SizeConfig.screenWidth * 0.4,
                          ),
                        ],
                      ),
                      AppSize.sh_15,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discount",
                            style: GoogleFonts.almarai(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          AppSize.sv_5,
                          BuildCoverTextWidget(
                            message: schoolActivitiesModel.discount,
                            width: SizeConfig.screenWidth * 0.4,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (schoolsCubit.activitiesJoinList.isNotEmpty) ...[
                    AppSize.sv_15,
                    Text(
                      "Children",
                      style: GoogleFonts.almarai(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    AppSize.sv_5,
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.11,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: schoolsCubit.activitiesJoinList.length,
                        itemBuilder: (context, index) {
                          ActivityJoinModel model =
                              schoolsCubit.activitiesJoinList[index];
                          return _buildChildrenItem(context, model);
                        },
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChildrenItem(BuildContext context, ActivityJoinModel model) {
    return InkWell(
      onTap: () {
        BlocProvider.of<SchoolsCubit>(context)
            .getChildForRequest(childId: model.childId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: BlocProvider.of<SchoolsCubit>(context),
              child: const SchoolActivitiesChildDetails(),
            ),
          ),
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
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(AppImages.childrenIcon),
            ),
            AppSize.sv_5,
          ],
        ),
      ),
    );
  }
}
