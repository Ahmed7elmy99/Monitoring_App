import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teatcher_app/modules/widgets/show_flutter_toast.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';

class EditParentProfileScreen extends StatefulWidget {
  const EditParentProfileScreen({super.key});

  @override
  State<EditParentProfileScreen> createState() =>
      _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController.text = PARENT_MODEL!.name;
    emailController.text = PARENT_MODEL!.email;
    passwordController.text = PARENT_MODEL!.password;
    phoneController.text = PARENT_MODEL!.phone;
    ageController.text = PARENT_MODEL!.age;
    genderController.text = PARENT_MODEL!.gender;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentUpdateProfileDataSuccessState) {
            showFlutterToast(
              message: 'Profile updated successfully ',
              toastColor: Colors.green,
            );
          }
          if (state is ParentUpdateProfileDataErrorState) {
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
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.25,
                            height: SizeConfig.screenHeight * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: parentCubit.parentImageFile == null
                                    ? NetworkImage(
                                        PARENT_MODEL!.image,
                                      )
                                    : FileImage(parentCubit.parentImageFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              parentCubit.updateParentProfileImage(
                                  userId: PARENT_MODEL!.id);
                            },
                            child: Container(
                              width: SizeConfig.screenWidth * 0.08,
                              height: SizeConfig.screenHeight * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                IconBroken.Camera,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_5,
                    AppTextFormFiledWidget(
                      controller: nameController,
                      hintText: "Enter your full name",
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
                      prefix: Icons.email,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Email";
                        } else if (!value.contains('@')) {
                          return "Please Enter Valid email address";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
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
                      keyboardType: TextInputType.text,
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
                    AppSize.sv_15,
                    const Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      keyboardType: TextInputType.phone,
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
                    state is ParentUpdateProfileDataLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: 'Save Changes',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                parentCubit.updateParentProfileData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
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
