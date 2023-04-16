import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class TeacherEditProfileScreen extends StatefulWidget {
  const TeacherEditProfileScreen({super.key});

  @override
  State<TeacherEditProfileScreen> createState() =>
      _TeacherEditProfileScreenState();
}

class _TeacherEditProfileScreenState extends State<TeacherEditProfileScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameController.text = TEACHER_MODEL?.name ?? '';
    emailController.text = TEACHER_MODEL?.email ?? '';
    passwordController.text = TEACHER_MODEL?.password ?? '';
    universityController.text = TEACHER_MODEL?.university ?? '';
    subjectController.text = TEACHER_MODEL?.subject ?? '';
    phoneController.text = TEACHER_MODEL?.phone ?? '';
    addressController.text = TEACHER_MODEL?.address ?? '';
    ageController.text = TEACHER_MODEL?.age ?? '';
    genderController.text = TEACHER_MODEL!.gender;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Edit Profile'),
      ),
      body: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {
          if (state is TeacherUpdateProfileSuccessState) {
            showFlutterToast(
              message: 'Profile Updated Successfully',
              toastColor: Colors.green,
            );
          }
          if (state is TeacherUpdateProfileErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          TeacherCubit teacherCubit = TeacherCubit.get(context);
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
                    AppSize.sv_5,
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
                    AppSize.sv_15,
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
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
                    AppSize.sv_15,
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
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
                    AppSize.sv_15,
                    const Text(
                      "University",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
                    AppTextFormFiledWidget(
                      controller: universityController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter your university",
                      prefix: Icons.school,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter University";
                        }

                        return null;
                      },
                    ),
                    AppSize.sv_15,
                    const Text(
                      "Subject",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
                    AppTextFormFiledWidget(
                      controller: subjectController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter your subject",
                      prefix: Icons.subject,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Subject";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_15,
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
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
                    AppSize.sv_15,
                    const Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
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
                    AppSize.sv_15,
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
                              AppSize.sv_5,
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
                              AppSize.sv_15,
                            ],
                          ),
                        ),
                        AppSize.sh_5,
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
                              AppSize.sv_5,
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
                              AppSize.sv_15,
                            ],
                          ),
                        )
                      ],
                    ),
                    AppSize.sv_15,
                    state is TeacherUpdateProfileLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Save Changes",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                teacherCubit.updateTeacherProfile(
                                  name: fullNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  university: universityController.text,
                                  subject: subjectController.text,
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
