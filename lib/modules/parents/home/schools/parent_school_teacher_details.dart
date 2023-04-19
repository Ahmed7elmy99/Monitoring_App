import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/modules/parents/home/schools/parent_message_teacher_screen.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/style/icon_broken.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/supervisors_model.dart';
import '../../../../models/teacher_model.dart';
import '../../../widgets/build_cover_text.dart';

class ParentSchoolTeacherDetails extends StatelessWidget {
  final SupervisorsModel? supervisorsModel;
  final TeacherModel? teacherModel;
  const ParentSchoolTeacherDetails(
      {super.key, this.supervisorsModel, this.teacherModel});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<ParentCubit, ParentState>(
      listener: (context, state) {},
      builder: (context, state) {
        ParentCubit parentCubit = ParentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
                '${teacherModel?.name == null ? supervisorsModel!.name : teacherModel!.name}'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: teacherModel?.id == null
                        ? supervisorsModel!.id
                        : teacherModel!.id,
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
                            teacherModel?.image == null
                                ? '${supervisorsModel!.image}'
                                : '${teacherModel!.image}'),
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
                      message: teacherModel?.name == null
                          ? supervisorsModel!.name
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
                      message: teacherModel?.email == null
                          ? supervisorsModel!.email
                          : teacherModel!.email),
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
                                    ? supervisorsModel!.phone
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
                                    ? supervisorsModel!.gender
                                    : teacherModel!.gender,
                                width: SizeConfig.screenWidth * 0.43),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            onPressed: teacherModel?.id == null
                ? () {
                    parentCubit.getMessages(receiverId: supervisorsModel!.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentMessageTeacherScreen(
                          supervisorsModel: supervisorsModel,
                        ),
                      ),
                    );
                  }
                : () {
                    parentCubit.getMessages(receiverId: teacherModel!.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentMessageTeacherScreen(
                          model: teacherModel,
                        ),
                      ),
                    );
                  },
            child: const Icon(
              IconBroken.Chat,
              size: 27.0,
            ),
          ),
        );
      },
    );
  }
}
