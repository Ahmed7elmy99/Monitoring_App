import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/parents/home/schools/parent_school_details_screen.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_model.dart';
import '../../../admin/widgets/app_textformfiled_widget.dart';
import '../../../widgets/const_widget.dart';

class ParentSchoolsSearchScreen extends StatelessWidget {
  ParentSchoolsSearchScreen({super.key});
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search School"),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              children: [
                AppSize.sv_15,
                AppTextFormFiledWidget(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  hintText: "enter location of school",
                  prefix: Icons.location_on,
                  onChanged: (value) {
                    parentCubit.getSchoolByLocation(
                        location: value.toString().toLowerCase());
                  },
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "Please enter location of school";
                    }
                    return null;
                  },
                ),
                AppSize.sv_10,
                parentCubit.parentSchoolByLocationList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            SchoolModel model =
                                parentCubit.parentSchoolByLocationList[index];
                            return _buildItemList(
                                context: context, school: model);
                          },
                          separatorBuilder: (context, index) => AppSize.sv_10,
                          itemCount:
                              parentCubit.parentSchoolByLocationList.length,
                        ),
                      )
                    : state is ParentGetSchoolByLocationLoadingState
                        ? CircularProgressComponent()
                        : Center(
                            child: Text(
                              "No Schools",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemList({
    required BuildContext context,
    required SchoolModel school,
  }) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ParentCubit>(context)
            .getAllSchoolsActivity(schoolId: school.id);
        BlocProvider.of<ParentCubit>(context)
            .getAllSchoolsTeachers(schoolId: school.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentSchoolsDetailsScreen(
              schoolModel: school,
            ),
          ),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        height: SizeConfig.screenWidth * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.27,
              height: SizeConfig.screenWidth * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    school.image,
                  ),
                ),
              ),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    school.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    school.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  AppSize.sv_2,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.teal,
                      ),
                      Text(
                        school.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
