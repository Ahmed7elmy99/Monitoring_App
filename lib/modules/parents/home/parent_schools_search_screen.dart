import 'package:flutter/material.dart';

import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';

class ParentSchoolsSearchScreen extends StatelessWidget {
  ParentSchoolsSearchScreen({super.key});
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search School"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: [
            AppSize.sv_15,
            AppTextFormFiledWidget(
              controller: searchController,
              keyboardType: TextInputType.text,
              hintText: "enter location of school",
              prefix: Icons.location_on,
              validate: (value) {
                if (value!.isEmpty) {
                  return "Please Ente Your Location";
                }
                return null;
              },
            ),
            AppSize.sv_10,
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => _buildItemList(
                  context: context,
                ),
                separatorBuilder: (context, index) => AppSize.sv_10,
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList({required BuildContext context}) {
    return Container(
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: SizeConfig.screenWidth * 0.27,
              height: SizeConfig.screenWidth * 0.31,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(AppImages.defaultImage),
                ),
              ),
            ),
          ),
          AppSize.sh_10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "School Name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSize.sv_10,
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                AppSize.sv_10,
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
