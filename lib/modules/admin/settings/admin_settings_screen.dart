import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/style/app_color.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../core/utils/screen_config.dart';
import '../../auth/widgets/build_auth_bottom.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        if (state is AuthAdminSignOutSuccessState) {
          Fluttertoast.showToast(
            msg: 'Sign out successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushReplacementNamed(
            context,
            Routers.LOGIN,
          );
        }
        if (state is AuthAdminSignOutErrorState) {
          Fluttertoast.showToast(
            msg: 'Sign out error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
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
                                image: NetworkImage(ADMIN_MODEL?.image ??
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
                                ADMIN_MODEL?.name ?? 'Paige Turner',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSize.sv_5,
                              Text(
                                ADMIN_MODEL?.email ?? '',
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
                              context, Routers.ADMIN_EDIT_PROFILE);
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
                title: 'New admin',
                leadingIcon: IconBroken.Profile,
                subtitle: 'Create new admin account',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routers.ADD_ADMIN,
                  );
                },
              ),
              _buildListItem(
                context,
                title: 'New school supervisor',
                leadingIcon: IconBroken.Profile,
                subtitle: 'Create new school supervisor account',
                onTap: () {
                  Navigator.pushNamed(context, Routers.ADD_SCHOOL);
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
                  cubit.signOut();
                },
              ),
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
