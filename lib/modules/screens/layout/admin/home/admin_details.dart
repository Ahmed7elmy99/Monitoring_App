import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/admin_models.dart';
import 'package:teatcher_app/modules/screens/layout/admin/home/update_admin_screen.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/style/icon_broken.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/screen_config.dart';

class AdminDetailsScreen extends StatelessWidget {
  const AdminDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context)!.settings.arguments as AdminModels;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Details'),
        actions: [
          IconButton(
            onPressed: () {
              if (model.createdAt!.compareTo(ADMIN_MODEL!.createdAt!) < 0) {
                Fluttertoast.showToast(
                  msg: 'You can\'t update this admin',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUpdateScreen(
                      adminModels: model,
                    ),
                  ),
                );
                print('update admin');
              }
            },
            icon: const Icon(IconBroken.Edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
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
                    backgroundImage: NetworkImage(model.image!),
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
              _buildCoverText(model.name),
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
              _buildCoverText(model.email),
              AppSize.sv_15,
              Text(
                'phone',
                style: GoogleFonts.almarai(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              AppSize.sv_5,
              _buildCoverText(model.phone),
              AppSize.sv_15,
              Row(
                children: [
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
                      _buildCoverText(model.gender,
                          width: SizeConfig.screenWidth * 0.43),
                    ],
                  ),
                  AppSize.sh_10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ban',
                        style: GoogleFonts.almarai(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      AppSize.sv_5,
                      _buildCoverText('${model.ban}',
                          width: SizeConfig.screenWidth * 0.43),
                    ],
                  ),
                ],
              ),
              AppSize.sv_10,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverText(String message, {double? width = 0}) {
    return Container(
      width: width == 0 ? SizeConfig.screenWidth : width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Text(
          message,
          maxLines: 13,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.almarai(
            height: 1.5,
            color: Colors.black45,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
