import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';

class CreateTeacherScreen extends StatelessWidget {
  CreateTeacherScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Teacher'),
        ),
        body: BlocConsumer<SchoolsCubit, SchoolsState>(
          listener: (context, state) {
            if (state is SchoolsAddTeacherSuccessState) {
              showFlutterToast(
                message: 'Teacher Added Successfully',
                toastColor: Colors.green,
              );
              Navigator.pop(context);
            }
            if (state is SchoolsAddTeacherErrorState) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSize.sv_10,
                      AppTextFormFiledWidget(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email",
                        prefix: Icons.email_rounded,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Email";
                          }
                          if (!value.contains('@')) {
                            return "Please Enter Valid Email";
                          }
                          return null;
                        },
                      ),
                      AppSize.sv_20,
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSize.sv_10,
                      AppTextFormFiledWidget(
                        controller: passwordController,
                        hintText: "Enter your password",
                        prefix: Icons.lock,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Password";
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
                        hintText: "Enter your phone",
                        prefix: Icons.call,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Phone";
                          }
                          return null;
                        },
                      ),
                      AppSize.sv_20,
                      const Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSize.sv_10,
                      AppTextFormFiledWidget(
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        hintText: "Enter location of school",
                        prefix: Icons.location_on,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please location of school";
                          }
                          return null;
                        },
                      ),
                      AppSize.sv_20,
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
                                  controller: ageController,
                                  hintText: "Enter your age",
                                  prefix: Icons.person,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter your age";
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
                                  controller: genderController,
                                  hintText: "Enter your gender",
                                  prefix: Icons.person,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter your gender";
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
                      state is SchoolsAddTeacherLoadingState
                          ? CircularProgressComponent()
                          : SaveChangesBottom(
                              textBottom: "Create Teacher",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  schoolsCubit.createTeacherAccount(
                                    name: fullNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    university: universityController.text,
                                    phone: phoneController.text,
                                    address: addressController.text,
                                    age: ageController.text,
                                    gender: genderController.text,
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
        ));
  }
}
