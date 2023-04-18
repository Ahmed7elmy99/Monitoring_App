import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/supervisors_model.dart';
import '../../../widgets/build_cover_text.dart';

class AdminSuperDetailsScreen extends StatelessWidget {
  final SupervisorsModel superModel;
  const AdminSuperDetailsScreen({super.key, required this.superModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${superModel.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: superModel.id,
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
                  backgroundImage: NetworkImage(superModel.image),
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
            BuildCoverTextWidget(message: superModel.name),
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
            BuildCoverTextWidget(message: superModel.email),
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
                          message: superModel.phone,
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
                          message: superModel.gender,
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
