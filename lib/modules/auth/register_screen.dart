import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/screen_config.dart';
import '../widgets/show_flutter_toast.dart';

import '../../controller/auth/auth_cubit.dart';
import '../../core/utils/app_images.dart';
import '../../core/utils/app_size.dart';
import '../admin/widgets/app_textformfiled_widget.dart';
import '../admin/widgets/save_changes_bottom.dart';
import '../widgets/const_widget.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.screenWidth * 0.7,
                  height: SizeConfig.screenHeight * 0.26,
                  decoration: const BoxDecoration(
                    // color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage("${AppImages.authLogo}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        keyboardType: TextInputType.text,
                        hintText: "Enter your name",
                        prefix: Icons.person,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter your name";
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
                          } else if (!value.contains('@')) {
                            return "Please Enter Valid email address";
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
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
                            return 'Please enter a password';
                          } else if (value.length < 8) {
                            return 'Password should be at least 8 characters long';
                          } else if (!value.contains(new RegExp(r'[A-Z]'))) {
                            return 'Password should contain at least one uppercase letter';
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
                                  "Phone",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AppSize.sv_10,
                                AppTextFormFiledWidget(
                                  keyboardType: TextInputType.number,
                                  controller: phoneController,
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
                                  hintText: "Enter your gender",
                                  prefix: Icons.person,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter gender";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      AppSize.sv_20,
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthRegisterUserSuccessState) {
                            showFlutterToast(
                              message: "Register Success",
                              toastColor: Colors.green,
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routers.PARENTS_LAYOUT_SCREEN,
                              (route) => false,
                            );
                          }
                          if (state is AuthRegisterUserErrorState) {
                            showFlutterToast(
                              message: state.error,
                              toastColor: Colors.red,
                            );
                          }
                        },
                        builder: (context, state) {
                          AuthCubit authCubit = AuthCubit.get(context);
                          return state is AuthRegisterUserLoadingState
                              ? CircularProgressComponent()
                              : SaveChangesBottom(
                                  textBottom: "Register",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      authCubit.registerUser(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        gender: genderController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                      AppSize.sv_10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            ),
                          ),
                          AppSize.sh_10,
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routers.LOGIN,
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
