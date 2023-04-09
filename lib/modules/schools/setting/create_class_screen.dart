import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class CreateClassScreen extends StatelessWidget {
  CreateClassScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController educationalLevelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsAddClassSuccessState) {
            showFlutterToast(
              message: 'Class added successfully',
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is SchoolsAddClassErrorState) {
            showFlutterToast(
              message: 'Error',
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: SizeConfig.screenWidth * 0.6,
                        height: SizeConfig.screenHeight * 0.3,
                        decoration: const BoxDecoration(
                          //color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage(AppImages.teacherLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: fullNameController,
                      hintText: "Enter teacher full name",
                      prefix: Icons.person,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Full Name";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Educational Level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: educationalLevelController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter educational level",
                      prefix: Icons.location_on,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Educational Level";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    state is SchoolsAddClassLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Create Class",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                schoolsCubit.createClass(
                                  className: fullNameController.text,
                                  eduLevel: educationalLevelController.text,
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
