import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/style/app_color.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import '../../widgets/build_list_title_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class TeacherSettingScreen extends StatelessWidget {
  const TeacherSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {
        if (state is TeacherSignOutSuccessState) {
          showFlutterToast(
            message: 'Teacher Sign out successfully',
            toastColor: Colors.green,
          );
          Navigator.pushReplacementNamed(
            context,
            Routers.LOGIN,
          );
        }
        if (state is TeacherSignOutErrorState) {
          showFlutterToast(message: state.error, toastColor: Colors.red);
        }
      },
      builder: (context, state) {
        TeacherCubit teacherCubit = TeacherCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight * 0.2,
                child: Stack(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.2,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.2,
                            height: SizeConfig.screenHeight * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  TEACHER_MODEL?.image == null
                                      ? AppImages.defaultImage
                                      : TEACHER_MODEL!.image,
                                ),
                              ),
                            ),
                          ),
                          AppSize.sh_10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TEACHER_MODEL?.name == null
                                    ? 'Paige Turner'
                                    : TEACHER_MODEL!.name,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSize.sv_5,
                              Text(
                                TEACHER_MODEL?.email == null
                                    ? 'example01@gmial.com'
                                    : TEACHER_MODEL!.email,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.2,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routers.TEACHERS_EDIT_PROFILE,
                          );
                        },
                        icon: Icon(
                          IconBroken.Edit,
                          color: AppColor.primerColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppSize.sv_10,
              BuildListTitleWidget(
                title: 'New Children',
                leadingIcon: IconBroken.Profile,
                subtitle: 'add new children to your account',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.ADD_CHILDREN_SCREEN,
                  );
                },
              ),
              const Spacer(),
              BottomComponent(
                child: Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 20.0),
                ),
                onPressed: () {
                  teacherCubit.signOutTeacher();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
