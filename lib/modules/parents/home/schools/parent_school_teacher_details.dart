import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/style/icon_broken.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../widgets/build_cover_text.dart';

class ParentSchoolTeacherDetails extends StatelessWidget {
  const ParentSchoolTeacherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final TeacherModel teacherModel =
        ModalRoute.of(context)!.settings.arguments as TeacherModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('${teacherModel.name}'),
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
                    tag: teacherModel.id,
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
                        backgroundImage: NetworkImage(teacherModel.image),
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
                  BuildCoverTextWidget(message: teacherModel.name),
                  AppSize.sv_15,
                  Text(
                    "Subject",
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: teacherModel.subject),
                  AppSize.sv_15,
                  Text(
                    "University",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: teacherModel.university),
                  AppSize.sv_15,
                  Text(
                    "Email",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(message: teacherModel.email),
                  AppSize.sv_15,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {},
        child: const Icon(
          IconBroken.Chat,
          size: 27.0,
        ),
      ),
    );
  }
}
