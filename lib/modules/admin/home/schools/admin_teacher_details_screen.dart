import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../widgets/build_cover_text.dart';

class AdminTeacherDetailsScreen extends StatelessWidget {
  final TeacherModel? teacherModel;
  final ChildrenModel? childModel;
  const AdminTeacherDetailsScreen(
      {super.key, this.childModel, this.teacherModel});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${teacherModel?.name == null ? childModel?.name : teacherModel?.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: teacherModel?.id == null ? childModel!.id : teacherModel!.id,
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
                  backgroundImage: NetworkImage(teacherModel?.image == null
                      ? childModel!.image
                      : teacherModel!.image),
                ),
              ),
            ),
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
            BuildCoverTextWidget(
                message: teacherModel?.name == null
                    ? childModel!.name
                    : teacherModel!.name),
            AppSize.sv_15,
            Text(
              "Email",
              style: GoogleFonts.almarai(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            AppSize.sv_5,
            BuildCoverTextWidget(
                message:
                    teacherModel?.email == null ? '' : teacherModel!.email),
            AppSize.sv_15,
            AppSize.sv_15,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'phone',
                        style: GoogleFonts.almarai(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      AppSize.sv_5,
                      BuildCoverTextWidget(
                          message: teacherModel?.phone == null
                              ? childModel!.phone
                              : teacherModel!.phone,
                          width: SizeConfig.screenWidth * 0.43),
                    ],
                  ),
                ),
                AppSize.sh_10,
                Expanded(
                  child: Column(
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
                          message: teacherModel?.gender == null
                              ? childModel!.gender
                              : teacherModel!.gender,
                          width: SizeConfig.screenWidth * 0.43),
                    ],
                  ),
                ),
              ],
            ),
            AppSize.sv_40,
          ],
        ),
      ),
    );
  }
}
