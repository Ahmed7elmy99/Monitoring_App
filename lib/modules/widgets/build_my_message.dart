import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/utils/app_size.dart';

import '../../core/utils/screen_config.dart';
import '../../models/message_model.dart';

class BuildMyMessageWidget extends StatelessWidget {
  final MessageModel model;
  final AlignmentDirectional alignment;
  final Color backgroundColor;
  const BuildMyMessageWidget({
    super.key,
    required this.model,
    required this.alignment,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.65),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: alignment == AlignmentDirectional.centerStart
                ? Radius.circular(0.0)
                : Radius.circular(13.0),
            bottomEnd: alignment == AlignmentDirectional.centerEnd
                ? Radius.circular(0.0)
                : Radius.circular(13.0),
            topStart: Radius.circular(13.0),
            topEnd: Radius.circular(13.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: alignment == AlignmentDirectional.centerStart
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              model.message,
              style: GoogleFonts.almarai(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
            ),
            AppSize.sv_2,
            Text(
              model.time!,
              style: GoogleFonts.almarai(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
