import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/style/app_color.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../models/message_model.dart';
import '../../../models/parent_model.dart';
import '../../widgets/build_my_message.dart';

class TeacherMessageParentScreen extends StatelessWidget {
  final ParentModel parentModel;
  TeacherMessageParentScreen({super.key, required this.parentModel});
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {},
      builder: (context, state) {
        TeacherCubit teacherCubit = TeacherCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('${parentModel.name}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: teacherCubit.messages.isNotEmpty
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel message = teacherCubit.messages[index];
                            if (TEACHER_MODEL!.id == message.senderId)
                              return BuildMyMessageWidget(
                                  model: message,
                                  alignment: AlignmentDirectional.centerEnd,
                                  backgroundColor:
                                      AppColor.primer.withOpacity(0.2));
                            return BuildMyMessageWidget(
                              model: message,
                              alignment: AlignmentDirectional.centerStart,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return AppSize.sv_10;
                          },
                          itemCount: teacherCubit.messages.length,
                        )
                      : Center(
                          child: Text('No messages yet'),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 50,
                    padding: EdgeInsetsDirectional.only(
                      start: 15,
                      end: 0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    child: TextFormField(
                      controller: messageController,
                      maxLines: 999,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message here...',
                        suffixIcon: MaterialButton(
                          height: 10,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            if (messageController.text.isNotEmpty) {
                              teacherCubit.sendMessage(
                                message: messageController.text,
                                receiverId: parentModel.id,
                              );
                              messageController.clear();
                            }

                            ;
                          },
                          color: AppColor.primer,
                          elevation: 10,
                          minWidth: 1,
                          child: Icon(
                            IconBroken.Send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
