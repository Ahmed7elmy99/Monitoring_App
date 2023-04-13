import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/controller/layout/schools/schools_cubit.dart';
import 'package:teatcher_app/core/routes/app_routes.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../core/style/app_color.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../auth/widgets/build_auth_bottom.dart';
import 'add_chilren_to clasee_screen.dart';

class SupervisorSettingsScreen extends StatelessWidget {
  const SupervisorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<SchoolsCubit, SchoolsState>(
      listener: (context, state) {
        if (state is SchoolSignOutSuccessState) {
          showFlutterToast(
            message: 'SuperVisor Sign out successfully',
            toastColor: Colors.green,
          );
          Navigator.pushReplacementNamed(
            context,
            Routers.LOGIN,
          );
        }
        if (state is SchoolSignOutErrorState) {
          showFlutterToast(message: state.error, toastColor: Colors.red);
        }
      },
      builder: (context, state) {
        SchoolsCubit cubit = SchoolsCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
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
                                image: NetworkImage(SUPERVISOR_MODEL?.image ??
                                    AppImages.defaultImage),
                              ),
                            ),
                          ),
                          AppSize.sh_10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                SUPERVISOR_MODEL?.name ?? 'Paige Turner',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSize.sv_5,
                              Text(
                                SUPERVISOR_MODEL?.email ?? '',
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
                              context, Routers.SUPERVISORS_EDIT_PROFILE);
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
              _buildListItem(
                context,
                title: 'Edit school',
                leadingIcon: Icons.school,
                subtitle: 'Edit school profile information',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.SCHOOL_EDIT_PROFILE,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'School Supervisor',
                leadingIcon: IconBroken.Profile,
                subtitle: 'Edit supervisor profile information',
                onTap: () {
                  cubit.getAllSupervisors();
                  Navigator.pushNamed(
                    context,
                    Routers.SCHOOL_SUPERVISOR,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'Add school Teacher',
                leadingIcon: IconBroken.Profile,
                subtitle: 'Create new school teacher account',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.CREATE_TEACHER,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'Add Activity',
                subtitle: 'Create new school activity',
                leadingIcon: IconBroken.Edit_Square,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.CREATE_SCHOOL_ACTIVITIES,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'Activity join',
                leadingIcon: IconBroken.Document,
                subtitle: 'show all activity join request',
                onTap: () {
                  cubit.getAllActivitiesJoiRequests();
                  Navigator.pushNamed(
                    context,
                    Routers.SCHOOL_ACTIVITIES_JOIN_SCREEN,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'School join',
                leadingIcon: IconBroken.Document,
                subtitle: 'show all school join request',
                onTap: () {
                  cubit.getAllRequests();
                  Navigator.pushNamed(
                    context,
                    Routers.SCHOOL_REQUESTS,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'Add Class',
                leadingIcon: IconBroken.Edit_Square,
                subtitle: 'Create new school class',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.CREATE_CLASS,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'Add Children to Class',
                leadingIcon: IconBroken.Edit_Square,
                subtitle: 'Add children to class room',
                onTap: () {
                  cubit.getAllSchoolClasses();
                  cubit.getAllSchoolChildren();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddChildrenToClass(),
                    ),
                  );
                },
              ),
              BottomComponent(
                  child: Text(
                    'Sign Out',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 20.0),
                  ),
                  onPressed: () {
                    cubit.signOutSupervisor();
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context,
      {required String title,
      required IconData leadingIcon,
      IconData? tailIcon,
      String? subtitle,
      Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      dense: true,
      splashColor: AppColor.primerColor.withOpacity(0.2),
      style: ListTileStyle.list,
      leading: Icon(
        leadingIcon,
        color: AppColor.primerColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(subtitle ?? ''),
      trailing: Icon(tailIcon),
    );
  }
}
