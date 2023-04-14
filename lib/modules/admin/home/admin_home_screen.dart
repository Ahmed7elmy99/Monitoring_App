import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/core/utils/dummy_data.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSize.sv_40,
                  AppSize.sv_40,
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth * 0.25,
                        height: SizeConfig.screenHeight * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                ADMIN_MODEL?.image ?? AppImages.defaultImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routers.ADMIN_EDIT_PROFILE,
                          );
                        },
                        child: Container(
                          width: SizeConfig.screenWidth * 0.08,
                          height: SizeConfig.screenHeight * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSize.sv_5,
                  Text(
                    ADMIN_MODEL?.name ?? 'Admin',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.sv_5,
                  Text(
                    ADMIN_MODEL?.email ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AppSize.sv_30,
                  GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: HomeModel.homeList.length,
                    itemBuilder: (context, index) {
                      HomeModel model = HomeModel.homeList[index];
                      return _buildListItem(context, item: model);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, {required HomeModel item}) {
    return InkWell(
      onTap: () {
        if (item.title == 'Parents') {
          BlocProvider.of<LayoutCubit>(context).getAllParent();
          Navigator.pushNamed(context, item.route);
        } else if (item.title == 'Admins') {
          BlocProvider.of<LayoutCubit>(context).getAllAdmins();
          Navigator.pushNamed(context, item.route);
        } else {
          Navigator.pushNamed(context, item.route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight * 0.13,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.3,
              height: SizeConfig.screenHeight * 0.15,
              decoration: BoxDecoration(
                //color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image(
                image: AssetImage(
                  item.image,
                ),
                width: SizeConfig.screenWidth * 0.18,
                height: SizeConfig.screenHeight * 0.09,
                fit: BoxFit.contain,
              ),
            ),
            AppSize.sv_10,
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: const Icon(
                      IconBroken.Arrow___Right_2,
                      size: 25.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
