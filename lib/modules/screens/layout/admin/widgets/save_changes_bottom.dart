import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/screen_config.dart';

class SaveChangesBottom extends StatelessWidget {
  final Function() onPressed;
  final String textBottom;
  const SaveChangesBottom({
    super.key,
    required this.onPressed,
    required this.textBottom,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize:
            Size(SizeConfig.screenWidth, SizeConfig.screenHeight * 0.07),
      ),
      onPressed: onPressed,
      child: Text(
        textBottom,
        style: GoogleFonts.almarai(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
