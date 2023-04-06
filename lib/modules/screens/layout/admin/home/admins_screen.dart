import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/core/routes/app_routes.dart';
import 'package:teatcher_app/core/style/app_color.dart';
import 'package:teatcher_app/models/admin_models.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../../controller/layout/layout_cubit.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/screen_config.dart';

class AdminsScreen extends StatelessWidget {
  const AdminsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admins Screen'),
        ),
        body: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            LayoutCubit cubit = LayoutCubit.get(context);
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: cubit.adminModelsList.length,
              itemBuilder: (context, index) {
                AdminModels request = cubit.adminModelsList[index];
                return _buildItemList(context, model: request);
              },
            );
          },
        ));
  }

  Widget _buildItemList(BuildContext context, {required AdminModels model}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routers.ADMIN_DETAILS_SCREEN,
        arguments: model,
      ),
      child: FadeInUp(
        from: 20,
        delay: Duration(milliseconds: 400),
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
                          backgroundImage: NetworkImage(model.image!),
                        ),
                      ),
                      AppSize.sh_15,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
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
                            AppSize.sv_10,
                            Text(
                              model.email,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.almarai(
                                color: Colors.black45,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
