import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class AddChildrenScreen extends StatefulWidget {
  AddChildrenScreen({super.key});

  @override
  State<AddChildrenScreen> createState() => _AddChildrenScreenState();
}

class _AddChildrenScreenState extends State<AddChildrenScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController educationController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController certificateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genderController.text = 'male';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Children'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentAddChildrenSuccessState) {
            showFlutterToast(
              message: 'Children Added Successfully',
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is ParentAddChildrenErrorState) {
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
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: SizeConfig.screenWidth * 0.6,
                        height: SizeConfig.screenHeight * 0.3,
                        decoration: const BoxDecoration(
                          //color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage(AppImages.childrenLogo),
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
                                    },
                                    items: ['male', 'female'].map((value) {
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
                        )
                      ],
                    ),
                    AppSize.sv_15,
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
                    state is ParentAddChildrenLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Add Children",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                parentCubit.addChildren(
                                  name: nameController.text,
                                  educationLevel: educationController.text,
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
