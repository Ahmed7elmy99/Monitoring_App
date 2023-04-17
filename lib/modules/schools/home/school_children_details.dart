import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/children_model.dart';
import '../../../models/report_model.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/build_cover_text.dart';
import '../../widgets/luanch_url.dart';
import '../../widgets/show_flutter_toast.dart';
import 'school_message_parent_screen.dart';
import 'widgets/school_children_attend_screen.dart';

class SchoolChildrenDetailsScreen extends StatefulWidget {
  final ChildrenModel childrenModel;
  const SchoolChildrenDetailsScreen({super.key, required this.childrenModel});

  @override
  State<SchoolChildrenDetailsScreen> createState() =>
      _SchoolChildrenDetailsScreenState();
}

class _SchoolChildrenDetailsScreenState
    extends State<SchoolChildrenDetailsScreen> {
  TextEditingController banController = TextEditingController();
  @override
  void initState() {
    super.initState();
    banController.text = widget.childrenModel.tracking.toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<SchoolsCubit, SchoolsState>(
      listener: (context, state) {
        if (state is SchoolsUnTrackingChildSuccessState) {
          banController.text == 'true'
              ? showFlutterToast(
                  message: 'Untracked successfully',
                  toastColor: Colors.green,
                )
              : showFlutterToast(
                  message: 'Tracked successfully',
                  toastColor: Colors.green,
                );
        }
      },
      builder: (context, state) {
        SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('School Children Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.childrenModel.id,
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
                        backgroundImage:
                            NetworkImage(widget.childrenModel.image),
                      ),
                    ),
                  ),
                  AppSize.sv_20,
                  Container(
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Untracked',
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
                            value: banController.text == 'false' ? false : true,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                banController.text = value.toString();
                              });
                              schoolsCubit.unTrackingChild(
                                childId: widget.childrenModel.id,
                                parentId: widget.childrenModel.parentId,
                                isTracking: value,
                              );
                            },
                          ),
                        ],
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
                  BuildCoverTextWidget(message: widget.childrenModel.name),
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
                  BuildCoverTextWidget(
                      message: widget.childrenModel.educationLevel),
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
                  BuildCoverTextWidget(message: widget.childrenModel.phone),
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
                            message: widget.childrenModel.age.toString(),
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
                            message: widget.childrenModel.gender,
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
                        message: widget.childrenModel.certificate,
                        width: SizeConfig.screenWidth * 0.7,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          launchURLFunction(widget.childrenModel.certificate);
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
                    "Parent Details",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.almarai(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
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
                  BuildCoverTextWidget(
                      message: schoolsCubit.parentModelForChildren?.name == null
                          ? ''
                          : schoolsCubit.parentModelForChildren!.name),
                  AppSize.sv_5,
                  Text(
                    "Phone",
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_5,
                  BuildCoverTextWidget(
                      message:
                          schoolsCubit.parentModelForChildren?.phone == null
                              ? ''
                              : schoolsCubit.parentModelForChildren!.phone),
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
                      message:
                          schoolsCubit.parentModelForChildren?.email == null
                              ? ''
                              : schoolsCubit.parentModelForChildren!.email),
                  AppSize.sv_15,
                  Text(
                    'Reports',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_10,
                  schoolsCubit.schoolsReportsList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.14,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: schoolsCubit.schoolsReportsList.length,
                            itemBuilder: (context, index) {
                              ReportModel model =
                                  schoolsCubit.schoolsReportsList[index];
                              return _buildReportCard(context, model);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'No reports yet  !!',
                            style: GoogleFonts.almarai(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  AppSize.sv_15,
                  Text(
                    'Schedules',
                    style: GoogleFonts.almarai(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  AppSize.sv_10,
                  SaveChangesBottom(
                    onPressed: () {
                      schoolsCubit.getAllAttendList(
                          childId: widget.childrenModel.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolChildrenAttendScreen(),
                        ),
                      );
                    },
                    textBottom: 'View Schedules',
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            onPressed: () {
              schoolsCubit.getMessages(
                  receiverId: schoolsCubit.parentModelForChildren!.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolMessageParentScreen(),
                ),
              );
            },
            child: const Icon(IconBroken.Chat),
          ),
        );
      },
    );
  }

  Widget _buildReportCard(BuildContext context, ReportModel reportModel) {
    return InkWell(
      onTap: () {
        launchURLFunction(reportModel.file);
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.25,
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
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage(AppImages.requestIcon),
            ),
            AppSize.sv_5,
          ],
        ),
      ),
    );
  }
}
