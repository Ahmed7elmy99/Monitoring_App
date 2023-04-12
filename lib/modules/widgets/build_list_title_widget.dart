import 'package:flutter/material.dart';

import '../../core/style/app_color.dart';

class BuildListTitleWidget extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final IconData? tailIcon;
  final String? subtitle;
  final Function()? onTap;
  const BuildListTitleWidget({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.tailIcon,
    this.subtitle = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      dense: true,
      splashColor: AppColor.primerColor.withOpacity(0.2),
      style: ListTileStyle.list,
      leading: Icon(
        leadingIcon,
        color: AppColor.primerColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(subtitle!),
      trailing: Icon(tailIcon),
    );
  }
}
