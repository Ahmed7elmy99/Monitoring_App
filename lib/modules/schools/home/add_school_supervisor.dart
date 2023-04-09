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

class AddSchoolSupervisorScreen extends StatelessWidget {
  AddSchoolSupervisorScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add school supervisor'),
        ),
        body: BlocConsumer<SchoolsCubit, SchoolsState>(
          listener: (context, state) {
            if (state is SchoolsAddSupervisorSuccessState) {
              showFlutterToast(
                message: "School supervisor added successfully",
                toastColor: Colors.green,
              );
              Navigator.pop(context);
            }
            if (state is SchoolsAddSupervisorErrorState) {
              showFlutterToast(message: state.error, toastColor: Colors.red);
            }
            if (state is SchoolsCreateSupervisorAccountErrorState) {
              showFlutterToast(message: state.error, toastColor: Colors.red);
            }
          },
          builder: (context, state) {
            SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                              image: AssetImage(AppImages.educationLogo),
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
                        controller: fullNameController,
                        hintText: "Enter your full name",
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
                      state is SchoolsAddSupervisorLoadingState
                          ? const CircularProgressComponent()
                          : SaveChangesBottom(
                              textBottom: "Add School Supervisor",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  schoolsCubit.createSuperVisorAccount(
                                    name: fullNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
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
