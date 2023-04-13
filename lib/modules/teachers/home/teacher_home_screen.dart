import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/dummy_data.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                              TEACHER_MODEL?.image ?? AppImages.defaultImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routers.SUPERVISORS_EDIT_PROFILE,
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
                  TEACHER_MODEL?.name ?? 'Supervisor name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSize.sv_5,
                Text(
                  TEACHER_MODEL?.email ?? 'Supervisor email',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                AppSize.sv_30,
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: SchoolHomeModel.schoolHomeList.length,
                  itemBuilder: (context, index) {
                    SchoolHomeModel model =
                        SchoolHomeModel.schoolHomeList[index];
                    return _buildListItem(context, item: model);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, {required SchoolHomeModel item}) {
    return Container();
  }
}
