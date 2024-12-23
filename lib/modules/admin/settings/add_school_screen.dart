import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teatcher_app/models/school_model.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/style/app_color.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/build_description_field.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';
import '../widgets/save_changes_bottom.dart';
import 'add_supervisor_screen.dart';

class AddSchoolScreen extends StatelessWidget {
  AddSchoolScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController establishedInController = TextEditingController();
  TextEditingController establishedByController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add school')),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutCheckSchoolPhoneErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
          if (state is LayoutCheckSchoolPhoneSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AddSupervisorScreen(
                  schlModel: SchoolModel(
                    id: '',
                    name: fullNameController.text,
                    description: descriptionController.text,
                    phone: phoneController.text,
                    location: locationController.text.toLowerCase(),
                    image: AppImages.defaultSchool,
                    establishedIn: establishedInController.text,
                    establishedBy: establishedByController.text,
                    website: websiteController.text,
                    ban: 'false',
                    createdAt: DateTime.now().toString(),
                  ),
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
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
                            image: AssetImage(AppImages.schoolLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "School Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: fullNameController,
                      hintText: "Enter school name",
                      prefix: Icons.person,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter school name";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    BuildDescriptionTextFiled(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      hintText: "Enter description of school",
                      prefix: Icons.add_box_rounded,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Description";
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
                        if (!startsWith05(value!)) {
                          return 'Phone number must start with 05';
                        }
                        if (!contains8Digits(value)) {
                          return 'Phone number must contain 8 digits';
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
                      controller: locationController,
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
                      "Established In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    InkWell(
                      onTap: () async {
                        _showPicker(context);
                      },
                      child: AppTextFormFiledWidget(
                        isEnable: false,
                        controller: establishedInController,
                        keyboardType: TextInputType.text,
                        hintText: "Enter date of established",
                        prefix: Icons.date_range,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter date of established";
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Established By",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: establishedByController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter person of established",
                      prefix: Icons.person,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter person of established";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Website",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    AppTextFormFiledWidget(
                      controller: websiteController,
                      keyboardType: TextInputType.text,
                      hintText: "Enter website of school",
                      prefix: Icons.link,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter website of school";
                        }
                        if (!value.contains("https://") &&
                            !value.contains("http://")) {
                          return "Please Enter valid website";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    state is LayoutAddSchoolLoadingState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Next Step ",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (establishedInController.text.isEmpty) {
                                  showFlutterToast(
                                    message: "Please Enter date of established",
                                    toastColor: Colors.red,
                                  );
                                } else {
                                  layoutCubit.checkNumberForSchool(
                                      phone: phoneController.text);
                                }
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

  Future<void> _showPicker(BuildContext context) async {
    String formattedDate = '';
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1910),
      lastDate: DateTime(2024),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primerColor,
              onPrimary: Colors.white,
              surface: AppColor.primerColor,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primerColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      formattedDate = DateFormat.y().format(pickedDate);
      establishedInController.text = formattedDate;
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
    } else {}
  }
}
