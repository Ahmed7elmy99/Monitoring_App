import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/build_cover_text.dart';
import '../../widgets/const_widget.dart';

class SchoolActivitiesChildDetails extends StatelessWidget {
  const SchoolActivitiesChildDetails({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Details'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {},
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetChildForRequestLoadingState
              ? CircularProgressComponent()
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
                        AppSize.sv_20,
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
                                  message: schoolsCubit
                                              .childrenRequestModel?.gender ==
                                          null
                                      ? 'female'
                                      : schoolsCubit
                                          .childrenRequestModel!.gender,
                                  width: SizeConfig.screenWidth * 0.42,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
