import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/supervisors_model.dart';

import '../../../../controller/layout/schools/schools_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../widgets/show_flutter_toast.dart';

class BuildSupervisorItem extends StatefulWidget {
  final SupervisorsModel model;
  const BuildSupervisorItem({super.key, required this.model});

  @override
  State<BuildSupervisorItem> createState() => _BuildSupervisorItemState();
}

class _BuildSupervisorItemState extends State<BuildSupervisorItem> {
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
                  widget.model.email,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.model.ban == 'false' ? 'Active' : 'Banned',
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
              if (state is SchoolsBanSupervisorSuccessState) {
                showFlutterToast(
                  message: banController.text == 'true'
                      ? 'Supervisor Banned'
                      : 'Supervisor Unbanned',
                  toastColor:
                      banController.text == 'true' ? Colors.red : Colors.green,
                );
              }
            },
            builder: (context, state) {
              return Switch(
                value: banController.text == 'false' ? false : true,
                activeColor: Colors.red,
                onChanged: (value) {
                  if (SUPERVISOR_MODEL!.createdAt
                          .compareTo(widget.model.createdAt) >
                      0) {
                    showFlutterToast(
                      message: 'You can\'t ban this supervisor',
                      toastColor: Colors.red,
                    );
                    return;
                  } else {
                    setState(() {
                      banController.text = value.toString();
                    });
                    BlocProvider.of<SchoolsCubit>(context).banSupervisor(
                      supervisorBan: banController.text,
                      supervisorId: widget.model.id,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
