import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';
import '../widgets/save_changes_bottom.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() => _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fullNameController.text = ADMIN_MODEL!.name;
    emailController.text = ADMIN_MODEL!.email;
    phoneController.text = ADMIN_MODEL!.phone;
    genderController.text = ADMIN_MODEL!.gender;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutUpdateUserDataSuccessState) {
            showFlutterToast(
              message: 'Update Data Success !',
              toastColor: Colors.green,
            );
          }
          if (state is LayoutUpdateUserImageErrorState) {
            showFlutterToast(message: state.error, toastColor: Colors.red);
          }
          if (state is LayoutUpdateUserDataErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                                image: layoutCubit.uploadImageFile == null
                                    ? NetworkImage(
                                        ADMIN_MODEL!.image ??
                                            AppImages.defaultImage,
                                      )
                                    : FileImage(layoutCubit.uploadImageFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => layoutCubit.getImageFromGallery(
                                uid: ADMIN_MODEL!.id),
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
                    AppSize.sv_15,
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
                      hintText: "Enter your email",
                      prefix: Icons.email,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Email";
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
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: passwordController,
                      hintText: "Enter your password",
                      isPassword: true,
                      suffix: Icons.visibility,
                      prefix: Icons.lock,
                      validate: (value) {
                        return null;
                      },
                    ),
                    AppSize.sv_15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ],
                          ),
                        ),
                        AppSize.sh_15,
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
                              Container(
                                width: SizeConfig.screenWidth * 0.4,
                                height: SizeConfig.screenHeight * 0.065,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: const Text(
                                      "Select status",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    value: genderController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        genderController.text =
                                            value.toString();
                                      });
                                      // layoutCubit
                                      //     .changeGender(value.toString());
                                    },
                                    items: layoutCubit.genderList.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSize.sv_15,
                    state is LayoutUpdateUserDataSuccessState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Save Changes",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                layoutCubit.updateUserData(
                                  adminName: fullNameController.text,
                                  adminPhone: phoneController.text,
                                  adminGen: genderController.text,
                                  emailAdmin: emailController.text,
                                  passwordAdmin: passwordController.text,
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
