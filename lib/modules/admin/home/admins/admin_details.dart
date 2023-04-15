import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../models/admin_models.dart';
import '../../../widgets/show_flutter_toast.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/const_data.dart';
import '../../../../core/utils/screen_config.dart';

class AdminDetailsScreen extends StatefulWidget {
  final AdminModels model;
  const AdminDetailsScreen({
    super.key,
    required this.model,
  });

  @override
  State<AdminDetailsScreen> createState() => _AdminDetailsScreenState();
}

class _AdminDetailsScreenState extends State<AdminDetailsScreen> {
  TextEditingController banController = TextEditingController();
  String _banValue = 'true';

  @override
  void initState() {
    super.initState();
    banController.text = widget.model.ban!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Details'),
        ),
        body: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {
            if (state is LayoutUpdateAdminsBanSuccessState) {
              showFlutterToast(
                  message: 'admin updated successfully',
                  toastColor: Colors.green);
            }
            if (state is LayoutUpdateAdminsBanErrorState) {
              showFlutterToast(
                  message: 'error in update admin', toastColor: Colors.red);
            }
          },
          builder: (context, state) {
            LayoutCubit layoutCubit = LayoutCubit.get(context);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: widget.model.id,
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
                          backgroundImage: NetworkImage(widget.model.image!),
                        ),
                      ),
                    ),
                    AppSize.sv_10,
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Ban',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.almarai(
                                height: 1.5,
                                color: Colors.black45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value:
                                  banController.text == 'false' ? false : true,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                if (widget.model.createdAt!
                                        .compareTo(ADMIN_MODEL!.createdAt!) <
                                    0) {
                                  showFlutterToast(
                                      message: 'you can\'t update this admin',
                                      toastColor: Colors.red);
                                } else {
                                  setState(() {
                                    banController.text = value.toString();
                                  });
                                  layoutCubit.updateAdminsBan(
                                    adminId: widget.model.id,
                                    adminBan: banController.text,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSize.sv_15,
                    Text(
                      "Name",
                      style: GoogleFonts.almarai(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    AppSize.sv_5,
                    _buildCoverText(widget.model.name),
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
                    _buildCoverText(widget.model.email),
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
                              _buildCoverText(widget.model.phone,
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
                              _buildCoverText(widget.model.gender,
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
          },
        ));
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
