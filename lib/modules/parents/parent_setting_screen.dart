import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/layout/parents/parent_cubit.dart';
import '../../core/routes/app_routes.dart';
import '../../core/style/app_color.dart';
import '../../core/style/icon_broken.dart';
import '../../core/utils/app_images.dart';
import '../../core/utils/app_size.dart';
import '../../core/utils/const_data.dart';
import '../../core/utils/screen_config.dart';
import '../auth/widgets/build_auth_bottom.dart';
import '../widgets/build_list_title_widget.dart';
import '../widgets/show_flutter_toast.dart';

class ParentSettingScreen extends StatelessWidget {
  const ParentSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<ParentCubit, ParentState>(
      listener: (context, state) {
        if (state is ParentSignOutSuccessState) {
          showFlutterToast(
            message: 'parent sign out success',
            toastColor: Colors.green,
          );
          Navigator.pushNamedAndRemoveUntil(
              context, Routers.LOGIN, (route) => false);
        }
        if (state is ParentSignOutErrorState) {
          showFlutterToast(
            message: 'error sign out',
            toastColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        ParentCubit parentCubit = ParentCubit.get(context);
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
                                  PARENT_MODEL?.image == null
                                      ? AppImages.defaultImage
                                      : PARENT_MODEL!.image,
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
                                PARENT_MODEL?.name == null
                                    ? 'Paige Turner'
                                    : PARENT_MODEL!.name,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              AppSize.sv_5,
                              Text(
                                PARENT_MODEL?.email == null
                                    ? 'example01@gmial.com'
                                    : PARENT_MODEL!.email,
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
                              context, Routers.PARENTS_EDIT_PROFILE);
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
              BuildListTitleWidget(
                title: 'School Requests',
                leadingIcon: IconBroken.Document,
                subtitle: 'show all requests to school',
                onTap: () {
                  parentCubit.getAllRequests();
                  Navigator.pushNamed(
                    context,
                    Routers.PARENTS_SHOW_REQUESTS_SCREEN,
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
                  parentCubit.signOutParent();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
