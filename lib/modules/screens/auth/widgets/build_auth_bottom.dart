import 'package:flutter/material.dart';
import 'package:teatcher_app/core/style/app_color.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';

class BottomComponent extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  const BottomComponent({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColor.primerColor.withOpacity(0.8),
        minimumSize: Size(
          SizeConfig.screenWidth * 0.9,
          SizeConfig.screenHeight * 0.065,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: child,
    );
  }
}
