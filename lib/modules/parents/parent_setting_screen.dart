import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/style/app_color.dart';
import '../../core/style/icon_broken.dart';
import '../../core/utils/app_images.dart';
import '../../core/utils/app_size.dart';
import '../../core/utils/screen_config.dart';
import '../auth/widgets/build_auth_bottom.dart';
import '../widgets/build_list_title_widget.dart';

class ParentSettingScreen extends StatelessWidget {
  const ParentSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                            image: NetworkImage(AppImages.defaultImage),
                          ),
                        ),
                      ),
                      AppSize.sh_10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Paige Turner',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          AppSize.sv_5,
                          Text(
                            ' email',
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
                      Navigator.pushNamed(context, Routers.ADMIN_EDIT_PROFILE);
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
          BuildListTitleWidget(
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
              // cubit.signOut();
            },
          ),
        ],
      ),
    );
  }
}
