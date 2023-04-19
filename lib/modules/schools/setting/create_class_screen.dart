import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/class_model.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class CreateClassScreen extends StatefulWidget {
  final ClassModel? classModel;
  final bool? isUpdate;
  CreateClassScreen({super.key, this.classModel, this.isUpdate = false});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController educationalLevelController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.isUpdate! ? widget.classModel!.name : '';
    educationalLevelController.text =
        widget.isUpdate! ? widget.classModel!.educationalLevel : '';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.isUpdate!
            ? const Text('Update Class')
            : const Text('Create Class'),
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
          if (state is SchoolsUpdateClassSuccessState) {
            showFlutterToast(
              message: 'Class updated successfully',
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
          if (state is SchoolsUpdateClassErrorState) {
            showFlutterToast(
              message: state.error,
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
                    state is SchoolsAddClassLoadingState ||
                            state is SchoolsUpdateClassLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: widget.isUpdate!
                                ? 'Update Class'
                                : 'Save Class',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (widget.isUpdate!) {
                                  schoolsCubit.updateClass(
                                    classId: widget.classModel!.id,
                                    className: fullNameController.text,
                                    eduLevel: educationalLevelController.text,
                                  );
                                } else {
                                  schoolsCubit.createClass(
                                    className: fullNameController.text,
                                    eduLevel: educationalLevelController.text,
                                  );
                                }
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
