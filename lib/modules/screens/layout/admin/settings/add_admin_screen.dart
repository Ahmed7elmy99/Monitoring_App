import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../controller/layout/layout_cubit.dart';
import '../../../../../core/style/icon_broken.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/screen_config.dart';
import '../../../../widgets/const_widget.dart';
import '../widgets/app_textformfiled_widget.dart';
import '../widgets/save_changes_bottom.dart';

class AddAdminScreen extends StatefulWidget {
  AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController genderController = TextEditingController();
  TextEditingController banController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _value = 'male';
  String _banValue = 'false';
  @override
  void initState() {
    super.initState();
    genderController.text = _value;
    banController.text = _banValue;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Add Admin")),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutCreateAdminAccountSuccessState) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "Admin Account Created Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
          if (state is LayoutCreateAdminAccountErrorState) {
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
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Form(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Gender",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AppSize.sv_10,
                                DropdownButton<String>(
                                  items: <String>[
                                    'male',
                                    'female',
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  value: _value,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 20.0,
                                  ),
                                  elevation: 16,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontWeight: FontWeight.w500),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _value = newValue!;
                                      genderController.text = _value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppSize.sh_20,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Ban",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              DropdownButton<String>(
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
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20.0,
                                ),
                                elevation: 16,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
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
                            ],
                          ),
                        )
                      ],
                    ),
                    AppSize.sv_20,
                    state is LayoutCreateAdminAccountLoadingState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Add Admin",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                layoutCubit.createAdminAccount(
                                  name: fullNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  gender: genderController.text,
                                  phone: phoneController.text,
                                  isBan: banController.text,
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
