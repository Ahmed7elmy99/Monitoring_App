import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';
import 'package:teatcher_app/models/children_model.dart';
import 'package:teatcher_app/modules/parents/home/children/parent_edit_children_screen.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/style/icon_broken.dart';
import '../../../../core/utils/app_size.dart';
import '../../../widgets/build_cover_text.dart';
import '../../../widgets/luanch_url.dart';

class ParentChildrenDetailsScreen extends StatelessWidget {
  final ChildrenModel childrenModel;
  const ParentChildrenDetailsScreen({super.key, required this.childrenModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ParentEditChildren(childrenModel: childrenModel),
                ),
              );
            },
            icon: const Icon(
              IconBroken.Edit_Square,
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
                    tag: childrenModel.id,
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
                        backgroundImage: NetworkImage(childrenModel.image),
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
                  BuildCoverTextWidget(message: childrenModel.name),
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
                  BuildCoverTextWidget(message: childrenModel.educationLevel),
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
                  BuildCoverTextWidget(message: childrenModel.phone),
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
                            message: childrenModel.age.toString(),
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
                            message: childrenModel.gender,
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
                        message: childrenModel.certificate,
                        width: SizeConfig.screenWidth * 0.7,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          launchURLFunction(childrenModel.certificate);
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                        ),
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