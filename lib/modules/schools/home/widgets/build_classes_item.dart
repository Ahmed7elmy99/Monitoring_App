import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';
import 'package:teatcher_app/models/class_model.dart';
import 'package:teatcher_app/modules/schools/home/school_classes_details_screen.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';

class BuildItemClassesWidget extends StatefulWidget {
  final ClassModel model;
  const BuildItemClassesWidget({super.key, required this.model});

  @override
  State<BuildItemClassesWidget> createState() => _BuildItemClassesWidgetState();
}

class _BuildItemClassesWidgetState extends State<BuildItemClassesWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return InkWell(
      onTap: () {
        BlocProvider.of<SchoolsCubit>(context)
            .getAllChildrenClass(classId: widget.model.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchoolClassDetailsScreen(
              classModel: widget.model,
            ),
          ),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.20,
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
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('${AppImages.classroomIcon2}'),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.model.educationalLevel,
                    maxLines: 1,
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
}
