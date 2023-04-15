import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'school_children_details.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/children_model.dart';
import '../../widgets/const_widget.dart';

class SchoolChildrenScreen extends StatelessWidget {
  const SchoolChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Children'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {},
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllTeachersLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsChildrenList.isEmpty
                  ? Center(
                      child: Text(
                        'No Children Yet',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        ChildrenModel item =
                            schoolsCubit.schoolsChildrenList[index];
                        return _buildRequestsItemWidget(context, model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: schoolsCubit.schoolsChildrenList.length,
                    );
        },
      ),
    );
  }

  Widget _buildRequestsItemWidget(BuildContext context,
      {required ChildrenModel model}) {
    return InkWell(
      onTap: () {
        BlocProvider.of<SchoolsCubit>(context)
            .getParentForChildren(parentId: model.parentId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchoolChildrenDetailsScreen(
              childrenModel: model,
            ),
          ),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.27,
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
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(model.image),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.sv_2,
                  Text(
                    model.educationLevel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    model.age.toString(),
                    style: const TextStyle(
                      fontSize: 13,
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
}
