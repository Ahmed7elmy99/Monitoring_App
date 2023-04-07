import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/models/supervisors_model.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_model.dart';

class SchoolDetailsScreen extends StatefulWidget {
  final SchoolModel schoolModel;
  const SchoolDetailsScreen({super.key, required this.schoolModel});

  @override
  State<SchoolDetailsScreen> createState() => _SchoolDetailsScreenState();
}

class _SchoolDetailsScreenState extends State<SchoolDetailsScreen> {
  TextEditingController banController = TextEditingController();
  bool supervisorIsBan = false;

  @override
  void initState() {
    super.initState();
    banController.text = widget.schoolModel.ban;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Details'),
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutChangeSchoolBanSuccessState) {
            showFlutterToast(
              message: banController.text == 'true'
                  ? 'School Banned'
                  : 'School Unbanned',
              toastColor:
                  banController.text == 'true' ? Colors.red : Colors.green,
            );
          }
          if (state is LayoutChangeSupervisorBanSuccessState) {
            showFlutterToast(
              message:
                  supervisorIsBan ? 'Supervisor Banned' : 'Supervisor Unbanned',
              toastColor: supervisorIsBan ? Colors.red : Colors.green,
            );
          }
        },
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.schoolModel.id,
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
                        backgroundImage: NetworkImage(widget.schoolModel.image),
                      ),
                    ),
                  ),
                  Center(
                    child: Switch(
                      value: banController.text == 'true' ? true : false,
                      activeColor: Colors.red,
                      splashRadius: 18.0,
                      onChanged: (value) {
                        setState(() {
                          banController.text = value.toString();
                        });
                        layoutCubit.changeSchoolBan(
                          schoolId: widget.schoolModel.id,
                          schoolBan: banController.text,
                        );
                      },
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
                  _buildCoverText(widget.schoolModel.name),
                  AppSize.sv_15,
                  Text(
                    "Description",
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  _buildCoverText(widget.schoolModel.description),
                  AppSize.sv_15,
                  Text(
                    "Established",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  _buildCoverText(widget.schoolModel.establishedIn),
                  AppSize.sv_15,
                  Text(
                    "Established By",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  _buildCoverText(widget.schoolModel.establishedBy),
                  AppSize.sv_15,
                  Text(
                    "Location",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  _buildCoverText(widget.schoolModel.location),
                  AppSize.sv_15,
                  Text(
                    'phone',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_15,
                  _buildCoverText(widget.schoolModel.phone),
                  AppSize.sv_15,
                  Text(
                    'School Website',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      _buildCoverText(
                        widget.schoolModel.website,
                        width: SizeConfig.screenWidth * 0.7,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _launchURL(widget.schoolModel.website);
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  AppSize.sv_15,
                  Text(
                    'School Supervisors',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  ListView.builder(
                    itemBuilder: (context, index) {
                      SupervisorsModel model =
                          layoutCubit.supervisorsModelsList[index];
                      return _buildSchoolSupervisorItem(context, item: model);
                    },
                    itemCount: layoutCubit.supervisorsModelsList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoverText(String message,
      {double? width = 0, int maxLines = 0}) {
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
          maxLines: maxLines == 0 ? 7 : maxLines,
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

  Widget _buildSchoolSupervisorItem(
    BuildContext context, {
    required SupervisorsModel item,
  }) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.09,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              item.image,
            ),
          ),
          AppSize.sh_10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              AppSize.sv_5,
              Text(
                item.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const Spacer(),
          Switch(
            value: supervisorIsBan,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                supervisorIsBan = value;
              });
              BlocProvider.of<LayoutCubit>(context).changeSupervisorBan(
                schoolId: widget.schoolModel.id,
                supervisorId: item.id,
                supervisorBan: supervisorIsBan.toString(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _launchURL(String website) async {
    final Uri parsedUri = Uri.parse(website);
    print(parsedUri);
    if (!await launchUrl(
      parsedUri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $parsedUri');
    }
  }
}
