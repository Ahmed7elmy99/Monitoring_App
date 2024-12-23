import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../../models/school_activities_model.dart';
import '../../../admin/widgets/save_changes_bottom.dart';
import '../../../widgets/build_cover_text.dart';
import '../../../widgets/const_widget.dart';
import '../../../widgets/show_flutter_toast.dart';

class ParentSchoolActivityJoinScreen extends StatefulWidget {
  const ParentSchoolActivityJoinScreen({super.key});

  @override
  State<ParentSchoolActivityJoinScreen> createState() =>
      _ParentSchoolActivityJoinScreenState();
}

class _ParentSchoolActivityJoinScreenState
    extends State<ParentSchoolActivityJoinScreen> {
  TextEditingController childIdController = TextEditingController();
  ChildrenModel? selectedChild;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final SchoolActivitiesModel schoolActivitiesModel =
        ModalRoute.of(context)!.settings.arguments as SchoolActivitiesModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Activity'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentCreateActivityJoinSuccessState) {
            Navigator.of(context).pop();
            showFlutterToast(
              message: 'Activity joined successfully',
              toastColor: Colors.green,
            );
          }
          if (state is ParentCreateActivityJoinErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: schoolActivitiesModel.id,
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
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage(AppImages.activityIcon01)),
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
                  BuildCoverTextWidget(message: schoolActivitiesModel.name),
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
                  BuildCoverTextWidget(
                      message: schoolActivitiesModel.description),
                  AppSize.sv_15,
                  const Text(
                    "Child Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSize.sv_10,
                  parentCubit.parentChildrenForActivityJoinList.isNotEmpty
                      ? Container(
                          width: SizeConfig.screenWidth * 0.4,
                          height: SizeConfig.screenHeight * 0.06,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<ChildrenModel>(
                            value: selectedChild,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            items: parentCubit.parentChildrenForActivityJoinList
                                .map((child) => DropdownMenuItem(
                                      value: child,
                                      key: Key(child.id),
                                      child: Text(child.name),
                                    ))
                                .toList(),
                            onChanged: (child) {
                              setState(() {
                                selectedChild = child;
                                childIdController.text = child!.name;
                              });
                            },
                          ),
                        )
                      : Container(),
                  AppSize.sv_20,
                  state is ParentCreateActivityJoinLoadingState
                      ? CircularProgressComponent()
                      : SaveChangesBottom(
                          textBottom: "Activity Join",
                          onPressed: () {
                            if (selectedChild == null) {
                              showFlutterToast(
                                message: 'Please select child',
                                toastColor: Colors.red,
                              );
                            } else if (selectedChild!.classId == '') {
                              showFlutterToast(
                                message: 'Please add child to school',
                                toastColor: Colors.red,
                              );
                            } else if (selectedChild!.activityId == '' ||
                                selectedChild!.activityId == 'rejected') {
                              parentCubit.crateActivityJoin(
                                activityId: schoolActivitiesModel.id,
                                childModel: selectedChild!,
                              );
                            } else {
                              showFlutterToast(
                                message: 'Child already joined activity',
                                toastColor: Colors.red,
                              );
                            }
                          },
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
