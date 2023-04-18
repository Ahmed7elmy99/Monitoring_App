import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/parent_model.dart';
import '../../../widgets/show_flutter_toast.dart';
import 'admin_parent_details.dart';

class BuildItemParentWidget extends StatefulWidget {
  final ParentModel model;
  const BuildItemParentWidget({super.key, required this.model});

  @override
  State<BuildItemParentWidget> createState() => _BuildItemParentWidgetState();
}

class _BuildItemParentWidgetState extends State<BuildItemParentWidget> {
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
          Hero(
            key: ValueKey(widget.model.id),
            tag: widget.model.id,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.model.image),
            ),
          ),
          AppSize.sh_10,
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminShowParentDetailsScreen(
                      model: widget.model,
                    ),
                  ),
                );
              },
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
                  AppSize.sv_5,
                  Text(
                    banController.text == 'false' ? '' : 'Banned',
                    style: TextStyle(
                      fontSize: 14,
                      color: '${banController.text}' == 'false'
                          ? Colors.transparent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<LayoutCubit, LayoutState>(
            listener: (context, state) {
              if (state is AdminBanParentSuccessState) {
                showFlutterToast(
                  message: banController.text == 'true'
                      ? 'Parent Banned'
                      : 'Parent Unbanned',
                  toastColor: Colors.green,
                );
              }
            },
            builder: (context, state) {
              return Switch(
                value: banController.text == 'false' ? false : true,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    banController.text = value.toString();
                  });
                  BlocProvider.of<LayoutCubit>(context).banParent(
                    parentId: widget.model.id,
                    parentBan: value.toString(),
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
