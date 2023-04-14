import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/controller/layout/parents/parent_cubit.dart';
import 'package:teatcher_app/core/utils/app_size.dart';
import 'package:teatcher_app/core/utils/const_data.dart';

import '../../../../core/style/app_color.dart';
import '../../../../core/style/icon_broken.dart';
import '../../../../models/message_model.dart';
import '../../../../models/supervisors_model.dart';
import '../../../../models/teacher_model.dart';

class ParentMessageTeacherScreen extends StatelessWidget {
  final TeacherModel? model;
  final SupervisorsModel? supervisorsModel;
  ParentMessageTeacherScreen({super.key, this.model, this.supervisorsModel});
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentState>(
      listener: (context, state) {},
      builder: (context, state) {
        ParentCubit parentCubit = ParentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Message Teacher'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: parentCubit.messages.isNotEmpty
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel message = parentCubit.messages[index];
                            if (PARENT_MODEL!.id == message.senderId)
                              return buildMyMessage(message);
                            return buildMessage(message);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return AppSize.sv_10;
                          },
                          itemCount: parentCubit.messages.length,
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
                              parentCubit.sendMessageToTeacher(
                                message: messageController.text,
                                receiverId: model?.id == null
                                    ? supervisorsModel!.id
                                    : model!.id,
                                schoolId: model?.schoolId == null
                                    ? supervisorsModel!.schoolsId
                                    : model!.schoolId,
                                isTeacher: model?.id == null ? false : true,
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

  Widget buildMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(
              10.0,
            ),
            topStart: Radius.circular(
              10.0,
            ),
            topEnd: Radius.circular(
              10.0,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Text(
          model.message,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildMyMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primer.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          model.message,
          style: GoogleFonts.almarai(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
