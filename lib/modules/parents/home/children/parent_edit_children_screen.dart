import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/style/icon_broken.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../admin/widgets/app_textformfiled_widget.dart';
import '../../../admin/widgets/save_changes_bottom.dart';
import '../../../widgets/const_widget.dart';
import '../../../widgets/show_flutter_toast.dart';

class ParentEditChildren extends StatefulWidget {
  final ChildrenModel childrenModel;
  const ParentEditChildren({super.key, required this.childrenModel});

  @override
  State<ParentEditChildren> createState() => _ParentEditChildrenState();
}

class _ParentEditChildrenState extends State<ParentEditChildren> {
  TextEditingController nameController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController certificateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.childrenModel.name;
    educationController.text = widget.childrenModel.educationLevel;
    ageController.text = widget.childrenModel.age.toString();
    genderController.text = widget.childrenModel.gender;
    phoneController.text = widget.childrenModel.phone;
    certificateController.text = widget.childrenModel.certificate;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Children'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentUpdateProfileImageSuccessState) {
            showFlutterToast(
              message: "Profile Image Updated Successfully",
              toastColor: Colors.green,
            );
          }
          if (state is ParentUpdateProfileSuccessState) {
            Navigator.pop(context);
            showFlutterToast(
              message: "Profile Updated Successfully",
              toastColor: Colors.green,
            );
          }
          if (state is ParentUpdateProfileErrorState) {
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
                                image: parentCubit.childrenImageFile == null
                                    ? NetworkImage(
                                        widget.childrenModel.image,
                                      )
                                    : FileImage(parentCubit.childrenImageFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              parentCubit.updateChildrenProfileImage(
                                  userId: widget.childrenModel.id);
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
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: nameController,
                      hintText: "enter name of the child",
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
                      hintText: "enter your phone",
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
                    AppSize.sv_10,
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
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                hintText: "enter age of the child",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter age of the child";
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
                                keyboardType: TextInputType.text,
                                controller: genderController,
                                hintText: "ender gender of the child",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter gender of the child";
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
                    const Text(
                      "Education level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: educationController,
                      hintText: "enter education level of the child",
                      prefix: Icons.storage_rounded,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter education level of the child";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "link of certificate",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: certificateController,
                      hintText: "enter link of certificate",
                      prefix: Icons.link,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter link of certificate";
                        } else if (!value.startsWith("https://")) {
                          return "Please Enter valid link of certificate";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    state is ParentUpdateProfileLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Update Children",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                parentCubit.updateChildrenProfile(
                                  id: widget.childrenModel.id,
                                  name: nameController.text,
                                  education: educationController.text,
                                  phone: phoneController.text,
                                  age: int.parse(ageController.text),
                                  gender: genderController.text,
                                  certificate: certificateController.text,
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
