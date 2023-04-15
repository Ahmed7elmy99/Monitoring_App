import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/teacher_model.dart';

class BuildItemTeachersWidget extends StatefulWidget {
  final TeacherModel model;
  const BuildItemTeachersWidget({super.key, required this.model});

  @override
  State<BuildItemTeachersWidget> createState() =>
      _BuildItemTeachersWidgetState();
}

class _BuildItemTeachersWidgetState extends State<BuildItemTeachersWidget> {
  TextEditingController banController = TextEditingController();
  @override
  void initState() {
    super.initState();
    banController.text = widget.model.ban;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
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
            backgroundImage: NetworkImage(widget.model.image),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSize.sv_2,
                Text(
                  widget.model.subject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.model.ban == 'false' ? '' : 'Banned',
                  style: TextStyle(
                    fontSize: 14,
                    color: '${widget.model.ban}' == 'false'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<SchoolsCubit, SchoolsState>(
            listener: (context, state) {
              if (state is SchoolsBanTeacherSuccessState) {}
            },
            builder: (context, state) {
              return Switch(
                value: banController.text == 'true' ? true : false,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    banController.text = value.toString();
                  });
                  BlocProvider.of<SchoolsCubit>(context).banSchoolTeacher(
                    teacherId: widget.model.id,
                    teacherBan: value.toString(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
