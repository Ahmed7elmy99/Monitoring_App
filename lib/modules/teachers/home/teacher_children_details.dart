import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/routes/app_routes.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/build_cover_text.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/luanch_url.dart';

class TeacherChildrenDetails extends StatelessWidget {
  const TeacherChildrenDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {
        if (state is TeacherUploadPdfSuccessState) {
          showFlutterToast(
            message: 'Report Uploaded Successfully',
            toastColor: Colors.green,
          );
        }
        if (state is TeacherUploadPdfErrorState) {
          showFlutterToast(
            message: state.error,
            toastColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        TeacherCubit teacherCubit = TeacherCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Children Details'),
          ),
          body: state is TeacherGetChildrenDataLoadingState ||
                  teacherCubit.childrenModel == null
              ? CircularProgressComponent()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: teacherCubit.childrenModel!.id,
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
                              backgroundImage: NetworkImage(
                                  teacherCubit.childrenModel!.image),
                            ),
                          ),
                        ),
                        AppSize.sv_15,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(
                                    SizeConfig.screenWidth * 0.4,
                                    SizeConfig.screenHeight * 0.06,
                                  ),
                                ),
                                onPressed: () {
                                  if (teacherCubit.childrenModel!.tracking ==
                                      false) {
                                    Navigator.pushNamed(
                                      context,
                                      Routers.TEACHERS_ATTENDANCE_SCREEN,
                                    );
                                  } else {
                                    showFlutterToast(
                                      message:
                                          'You can not add attendance for this child',
                                      toastColor: Colors.red,
                                    );
                                  }
                                  ;
                                },
                                child: Text('Attendance'),
                              ),
                            ),
                            AppSize.sh_10,
                            Expanded(
                              child: state is TeacherUploadPdfLoadingState
                                  ? CircularProgressComponent()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal.shade300,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        minimumSize: Size(
                                          SizeConfig.screenWidth * 0.4,
                                          SizeConfig.screenHeight * 0.06,
                                        ),
                                      ),
                                      onPressed: () {
                                        teacherCubit.uploadPdfToFirebase();
                                      },
                                      child: Text('Report'),
                                    ),
                            ),
                          ],
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
                            message: teacherCubit.childrenModel!.name),
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
                            message:
                                teacherCubit.childrenModel!.educationLevel),
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
                        BuildCoverTextWidget(
                            message: teacherCubit.childrenModel!.phone),
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
                                  message: teacherCubit.childrenModel!.age
                                      .toString(),
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
                                  message: teacherCubit.childrenModel!.gender,
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
                              message: teacherCubit.childrenModel!.certificate,
                              width: SizeConfig.screenWidth * 0.7,
                              maxLines: 1,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                launchURLFunction(
                                    teacherCubit.childrenModel!.certificate);
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
                            message: teacherCubit.parentModel?.name == null
                                ? ''
                                : teacherCubit.parentModel!.name),
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
                            message: teacherCubit.parentModel?.phone == null
                                ? ''
                                : teacherCubit.parentModel!.phone),
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
                            message: teacherCubit.parentModel?.email == null
                                ? ''
                                : teacherCubit.parentModel!.email),
                        AppSize.sv_15,
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.teal.withOpacity(0.8),
            child: const Icon(
              IconBroken.Chat,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
