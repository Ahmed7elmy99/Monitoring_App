import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/models/parent_model.dart';

import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../widgets/build_cover_text.dart';

class AdminShowParentDetailsScreen extends StatelessWidget {
  final ParentModel model;
  const AdminShowParentDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${model.name} ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(),
        ),
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: model.id,
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
                      backgroundImage: NetworkImage(model.image),
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
                BuildCoverTextWidget(message: model.name),
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
                BuildCoverTextWidget(message: model.email),
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
                              message: model.phone,
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
                              message: model.gender,
                              width: SizeConfig.screenWidth * 0.43),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSize.sv_40,
              ],
            ),
          );
        },
      ),
    );
  }
}
