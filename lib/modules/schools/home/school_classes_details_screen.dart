import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/class_join_Model.dart';
import '../../../models/class_model.dart';
import '../../widgets/build_cover_text.dart';
import '../setting/create_class_screen.dart';

class SchoolClassDetailsScreen extends StatelessWidget {
  final ClassModel classModel;
  const SchoolClassDetailsScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('School Class Details'), actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateClassScreen(
                  classModel: classModel,
                  isUpdate: true,
                ),
              ),
            );
          },
          icon: const Icon(
            IconBroken.Edit_Square,
          ),
        ),
      ]),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {},
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: classModel.id,
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
                          backgroundImage: AssetImage(AppImages.classroomIcon)),
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
                  BuildCoverTextWidget(message: classModel.name),
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
                  BuildCoverTextWidget(message: classModel.educationalLevel),
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
                  schoolsCubit.childrenClassJoin.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.11,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: schoolsCubit.childrenClassJoin.length,
                            itemBuilder: (context, index) {
                              ClassJoinModel model =
                                  schoolsCubit.childrenClassJoin[index];
                              return _buildChildrenItem(model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Children in this class',
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
    );
  }

  Widget _buildChildrenItem(ClassJoinModel model) {
    return InkWell(
      onTap: () {},
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