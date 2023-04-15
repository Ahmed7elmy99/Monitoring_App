import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'school_details_screen.dart';

import '../../../../controller/layout/admins/layout_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/school_model.dart';

class SchoolsScreen extends StatelessWidget {
  const SchoolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools'),
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          LayoutCubit cubit = LayoutCubit.get(context);
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: cubit.schoolModelsList.length,
            itemBuilder: (context, index) {
              SchoolModel request = cubit.schoolModelsList[index];
              return _buildItemList(context, model: request);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemList(BuildContext context, {required SchoolModel model}) {
    return FadeInUp(
      from: 20,
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight * 0.16,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: model.id,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(model.image),
                      ),
                    ),
                    AppSize.sh_15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.almarai(
                              color: Colors.black45,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppSize.sv_5,
                          Text(
                            model.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: Colors.black45,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          AppSize.sv_10,
                          Text(
                            model.ban == 'true' ? 'Banned' : '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.almarai(
                              color: model.ban == 'true'
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<LayoutCubit>(context)
                            .getAllSupervisors(schoolId: model.id);
                        BlocProvider.of<LayoutCubit>(context)
                            .getAllTeachers(schoolId: model.id);
                        BlocProvider.of<LayoutCubit>(context)
                            .getAllChildren(schoolId: model.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchoolDetailsScreen(
                              schoolModel: model,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: SizeConfig.screenWidth * 0.14,
                        height: SizeConfig.screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade300,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
