import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';

class TeacherEditProfileScreen extends StatefulWidget {
  const TeacherEditProfileScreen({super.key});

  @override
  State<TeacherEditProfileScreen> createState() =>
      _TeacherEditProfileScreenState();
}

class _TeacherEditProfileScreenState extends State<TeacherEditProfileScreen> {
  TextEditingController fullNameController = TextEditingController();
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
                      "University",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
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
                    AppSize.sv_20,
                    const Text(
                      "Subject",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
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
                    state is TeacherUpdateProfileLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Save Changes",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                teacherCubit.updateTeacherProfile(
                                  name: fullNameController.text,
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
}
