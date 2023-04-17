import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../../models/school_model.dart';
import '../../../../models/supervisors_model.dart';
import '../../../../models/teacher_model.dart';
import '../../../widgets/build_cover_text.dart';
import '../../../widgets/luanch_url.dart';
import '../../../widgets/show_flutter_toast.dart';

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
        title: const Text('School Details'),
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
        },
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  BuildCoverTextWidget(message: widget.schoolModel.name),
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
                  BuildCoverTextWidget(message: widget.schoolModel.description),
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
                  BuildCoverTextWidget(
                      message: widget.schoolModel.establishedIn),
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
                  BuildCoverTextWidget(
                      message: widget.schoolModel.establishedBy),
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
                  BuildCoverTextWidget(message: widget.schoolModel.location),
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
                  BuildCoverTextWidget(message: widget.schoolModel.phone),
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
                      BuildCoverTextWidget(
                        message: widget.schoolModel.website,
                        width: SizeConfig.screenWidth * 0.7,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          launchURLFunction(widget.schoolModel.website);
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
                    'Teachers',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  layoutCubit.teachersList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: layoutCubit.teachersList.length,
                            itemBuilder: (context, index) {
                              TeacherModel model =
                                  layoutCubit.teachersList[index];
                              return _buildTeacherCard(context, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No teachers yet  !!',
                            style: GoogleFonts.almarai(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  AppSize.sv_15,
                  Text(
                    'Children',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  layoutCubit.childrenList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.15,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            scrollDirection: Axis.horizontal,
                            itemCount: layoutCubit.childrenList.length,
                            itemBuilder: (context, index) {
                              ChildrenModel model =
                                  layoutCubit.childrenList[index];
                              return _buildChildrenCard(context, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No children yet  !!',
                            style: GoogleFonts.almarai(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  AppSize.sv_5,
                  AppSize.sv_15,
                  Text(
                    'Supervisors',
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSchoolSupervisorItem(BuildContext context,
      {required SupervisorsModel item}) {
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
        ],
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, TeacherModel teacherModel) {
    return Container(
      width: SizeConfig.screenWidth * 0.27,
      margin: const EdgeInsets.only(right: 10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
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
            backgroundImage: NetworkImage(teacherModel.image),
          ),
          AppSize.sv_5,
          Text(
            teacherModel.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.almarai(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenCard(BuildContext context, ChildrenModel childrenModel) {
    return Container(
      width: SizeConfig.screenWidth * 0.27,
      margin: const EdgeInsets.only(right: 10.0),
      //padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
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
            backgroundImage: NetworkImage(childrenModel.image),
          ),
          AppSize.sv_5,
          Text(
            childrenModel.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.almarai(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
