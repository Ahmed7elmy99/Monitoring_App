import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/routes/app_routes.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';
import 'package:teatcher_app/modules/auth/widgets/build_auth_bottom.dart';
import 'package:teatcher_app/modules/auth/widgets/build_text_form_filed.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../controller/auth/auth_cubit.dart';
import '../../core/utils/app_size.dart';
import '../widgets/const_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthGetUserAfterLoginSuccessState) {
          if (state.message == 'admin') {
            Navigator.pushReplacementNamed(context, Routers.ADMIN_LAYOUT);
          } else if (state.message == 'parent') {
            Navigator.pushReplacementNamed(
                context, Routers.PARENTS_LAYOUT_SCREEN);
          } else if (state.message == 'teacher') {
            Navigator.pushReplacementNamed(
                context, Routers.TEACHERS_LAYOUT_SCREEN);
          } else if (state.message == 'supervisor') {
            Navigator.pushReplacementNamed(
                context, Routers.SUPERVISORS_LAYOUT_SCREEN);
          }
        }
        if (state is AuthGetUserAfterLoginErrorState) {
          showFlutterToast(
            message: state.error,
            toastColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      AppSize.sv_20,
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormFiledComponent(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Email',
                              prefixIcon: Icons.email,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }

                                return null;
                              },
                            ),
                            AppSize.sv_10,
                            TextFormFiledComponent(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              // obscureText: true,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            AppSize.sv_20,
                            state is AuthGetUserAfterLoginLoadingState
                                ? CircularProgressComponent()
                                : BottomComponent(
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        authCubit.userMakLogin(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                  ),
                            AppSize.sv_5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45,
                                  ),
                                ),
                                AppSize.sh_10,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routers.REGISTER_SCREEN,
                                    );
                                  },
                                  child: const Text(
                                    'Register',
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
          ),
        );
      },
    );
  }
}
