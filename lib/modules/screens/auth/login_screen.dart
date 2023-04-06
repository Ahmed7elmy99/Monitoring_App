import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teatcher_app/core/routes/app_routes.dart';
import 'package:teatcher_app/core/utils/app_images.dart';
import 'package:teatcher_app/core/utils/screen_config.dart';
import 'package:teatcher_app/modules/screens/auth/widgets/build_auth_bottom.dart';
import 'package:teatcher_app/modules/screens/auth/widgets/build_text_form_filed.dart';

import '../../../controller/auth/auth_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../widgets/const_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                        image: AssetImage("assets/images/appLogo.png"),
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
                          validator: (value) {
                            if (value.isEmpty) {
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
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        AppSize.sv_20,
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthUserLoginErrorState) {
                              Fluttertoast.showToast(
                                msg: state.error,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                            if (state is AuthGetUserAfterLoginSuccessState) {
                              Fluttertoast.showToast(
                                msg: 'Login Success',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                Routers.ADMIN_LAYOUT,
                              );
                            }
                            if (state is AuthGetUserAfterLoginErrorState) {
                              Fluttertoast.showToast(
                                msg: state.error,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          builder: (context, state) {
                            AuthCubit cubit = AuthCubit.get(context);
                            return BottomComponent(
                              child: state is AuthUserLoginLoadingState
                                  ? const CircularProgressComponent()
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                            );
                          },
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
  }
}
