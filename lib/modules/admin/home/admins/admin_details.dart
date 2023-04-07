import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/controller/layout/admins/layout_cubit.dart';
import 'package:teatcher_app/models/admin_models.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/const_data.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../widgets/const_widget.dart';
import '../../widgets/save_changes_bottom.dart';

class AdminDetailsScreen extends StatefulWidget {
  final AdminModels model;
  const AdminDetailsScreen({
    super.key,
    required this.model,
  });

  @override
  State<AdminDetailsScreen> createState() => _AdminDetailsScreenState();
}

class _AdminDetailsScreenState extends State<AdminDetailsScreen> {
  TextEditingController banController = TextEditingController();
  String _banValue = 'true';

  @override
  void initState() {
    super.initState();
    banController.text = widget.model.ban!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.model.id,
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  final Hero toHero = toHeroContext.widget as Hero;
                  return RotationTransition(
                    turns: animation,
                    child: toHero.child,
                  );
                },
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.model.image!),
                  ),
                ),
              ),
              AppSize.sv_10,
              Text(
                "Name",
                style: GoogleFonts.almarai(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              AppSize.sv_5,
              _buildCoverText(widget.model.name),
              AppSize.sv_15,
              Text(
                "Email",
                style: GoogleFonts.almarai(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              AppSize.sv_5,
              _buildCoverText(widget.model.email),
              AppSize.sv_15,
              Text(
                'phone',
                style: GoogleFonts.almarai(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              AppSize.sv_5,
              _buildCoverText(widget.model.phone),
              AppSize.sv_15,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: GoogleFonts.almarai(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      AppSize.sv_5,
                      _buildCoverText(widget.model.gender,
                          width: SizeConfig.screenWidth * 0.43),
                    ],
                  ),
                  AppSize.sh_10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ban',
                        style: GoogleFonts.almarai(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      AppSize.sv_5,
                      Container(
                        width: SizeConfig.screenWidth * 0.43,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: DropdownButton<String>(
                            items: <String>[
                              'true',
                              'false',
                            ].map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            value: _banValue,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 20.0,
                            ),
                            elevation: 16,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _banValue = newValue!;
                                banController.text = _banValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSize.sv_40,
              BlocConsumer<LayoutCubit, LayoutState>(
                listener: (context, state) {
                  if (state is LayoutUpdateAdminsBanSuccessState) {
                    showFlutterToast(
                        message: 'admin updated successfully',
                        toastColor: Colors.green);
                  }
                  if (state is LayoutUpdateAdminsBanErrorState) {
                    showFlutterToast(
                        message: 'error in update admin',
                        toastColor: Colors.red);
                  }
                },
                builder: (context, state) {
                  return state is LayoutUpdateAdminsBanLoadingState
                      ? const CircularProgressComponent()
                      : SaveChangesBottom(
                          onPressed: () {
                            if (widget.model.createdAt!
                                    .compareTo(ADMIN_MODEL!.createdAt!) <
                                0) {
                              showFlutterToast(
                                  message: 'you can\'t update this admin',
                                  toastColor: Colors.red);
                            } else {
                              BlocProvider.of<LayoutCubit>(context)
                                  .updateAdminsBan(
                                adminId: widget.model.id,
                                adminBan: banController.text,
                              );
                            }
                          },
                          textBottom: 'update admin',
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverText(String message, {double? width = 0}) {
    return Container(
      width: width == 0 ? SizeConfig.screenWidth : width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Text(
          message,
          maxLines: 13,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.almarai(
            height: 1.5,
            color: Colors.black45,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
