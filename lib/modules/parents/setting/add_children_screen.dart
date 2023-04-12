import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';

class AddChildrenScreen extends StatelessWidget {
  AddChildrenScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController certificateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Children'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentAddChildrenSuccessState) {
            showFlutterToast(
              message: 'Children Added Successfully',
              toastColor: Colors.green,
            );
          }
          if (state is ParentAddChildrenErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
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
                            image: AssetImage(AppImages.childrenLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: nameController,
                      hintText: "enter name of the child",
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
                      "Phone",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: "enter your phone",
                      prefix: Icons.call,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Phone";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_10,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Age",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AppSize.sv_10,
                              AppTextFormFiledWidget(
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                hintText: "enter age of the child",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter age of the child";
                                  }
                                  return null;
                                },
                              ),
                              AppSize.sv_20,
                            ],
                          ),
                        ),
                        AppSize.sh_10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AppSize.sv_10,
                              AppTextFormFiledWidget(
                                keyboardType: TextInputType.text,
                                controller: genderController,
                                hintText: "ender gender of the child",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter gender of the child";
                                  }
                                  return null;
                                },
                              ),
                              AppSize.sv_20,
                            ],
                          ),
                        )
                      ],
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Education level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: educationController,
                      hintText: "enter education level of the child",
                      prefix: Icons.storage_rounded,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter education level of the child";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "link of certificate",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: certificateController,
                      hintText: "enter link of certificate",
                      prefix: Icons.link,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter link of certificate";
                        } else if (!value.startsWith("https://")) {
                          return "Please Enter valid link of certificate";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    state is ParentAddChildrenLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Add Children",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                parentCubit.addChildren(
                                  name: nameController.text,
                                  educationLevel: educationController.text,
                                  phone: phoneController.text,
                                  age: int.parse(ageController.text),
                                  gender: genderController.text,
                                  certificate: certificateController.text,
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
