import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/style/icon_broken.dart';
import 'package:teatcher_app/modules/parents/home/schools/parent_school_details_screen.dart';
import 'package:teatcher_app/modules/parents/home/schools/parent_schools_search_screen.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_model.dart';
import '../../../widgets/const_widget.dart';

class ParentSchoolsScreen extends StatelessWidget {
  const ParentSchoolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schools'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentSchoolsSearchScreen(),
                ),
              );
            },
            icon: const Icon(
              IconBroken.Search,
              size: 20.0,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return state is ParentGetAllSchoolsLoadingState
              ? CircularProgressComponent()
              : parentCubit.parentSchoolsList.isEmpty
                  ? Center(
                      child: Text(
                        'No Schools',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        SchoolModel item = parentCubit.parentSchoolsList[index];
                        return _buildItemList(context, item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: parentCubit.parentSchoolsList.length,
                    );
        },
      ),
    );
  }
}

Widget _buildItemList(BuildContext context, SchoolModel model) {
  return InkWell(
    onTap: () {
      BlocProvider.of<ParentCubit>(context)
          .getAllSchoolsActivity(schoolId: model.id);
      BlocProvider.of<ParentCubit>(context)
          .getAllSchoolsTeachers(schoolId: model.id);
      BlocProvider.of<ParentCubit>(context)
          .getAllSchoolsSupervisors(schoolId: model.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParentSchoolsDetailsScreen(
            schoolModel: model,
          ),
        ),
      );
    },
    child: Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.26,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: model.id,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('${model.image}'),
            ),
          ),
          AppSize.sh_10,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
