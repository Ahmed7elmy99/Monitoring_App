import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';
import '../widgets/app_textformfiled_widget.dart';
import '../widgets/save_changes_bottom.dart';

class AddSupervisorScreen extends StatelessWidget {
  AddSupervisorScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add school supervisor')),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutAddSchoolSupervisorSuccessState) {
            showFlutterToast(
              message: "School supervisor added successfully",
              toastColor: Colors.green,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routers.ADMIN_LAYOUT,
              (route) => false,
            );
          }
          if (state is LayoutAddSchoolSupervisorErrorState) {
            showFlutterToast(message: state.error, toastColor: Colors.red);
          }
          if (state is LayoutCreateSuperVisorAccountErrorState) {
            showFlutterToast(message: state.error, toastColor: Colors.red);
          }
        },
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
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
                        if (!startsWith05(value!)) {
                          return 'Phone number must start with 05';
                        }
                        if (!contains8Digits(value)) {
                          return 'Phone number must contain 8 digits';
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    state is LayoutAddSchoolSupervisorLoadingState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Add School Supervisor",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                layoutCubit.createSuperVisorAccount(
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
      ),
    );
  }

  bool startsWith05(String number) {
    if (number.isEmpty) {
      return false;
    }
    return number.startsWith('05');
  }

  bool contains8Digits(String number) {
    if (number.isEmpty) {
      return false;
    }
    return RegExp(r'^\d{8}$').hasMatch(number.substring(2));
  }
}
