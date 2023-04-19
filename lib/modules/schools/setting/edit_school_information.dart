import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/style/app_color.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/const_data.dart';
import '../../../core/utils/screen_config.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class EditSchoolInformation extends StatefulWidget {
  const EditSchoolInformation({super.key});

  @override
  State<EditSchoolInformation> createState() => _EditSchoolInformationState();
}

class _EditSchoolInformationState extends State<EditSchoolInformation> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController establishedInController = TextEditingController();
  TextEditingController establishedByController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fullNameController.text = SCHOOL_MODEL!.name;
    descriptionController.text = SCHOOL_MODEL!.description;
    phoneController.text = SCHOOL_MODEL!.phone;
    locationController.text = SCHOOL_MODEL!.location;
    establishedInController.text = SCHOOL_MODEL!.establishedIn;
    establishedByController.text = SCHOOL_MODEL!.establishedBy;
    websiteController.text = SCHOOL_MODEL!.website;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit School Information"),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsUpdateProfileSuccessState) {
            showFlutterToast(
              message: "School information updated successfully",
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is SchoolsUpdateProfileErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
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
                                image: schoolsCubit.schoolProfileFile == null
                                    ? NetworkImage(
                                        SCHOOL_MODEL!.image,
                                      )
                                    : FileImage(schoolsCubit.schoolProfileFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              schoolsCubit.updateSchoolProfileImage();
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
                    AppTextFormFiledWidget(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
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
                    state is SchoolsUpdateProfileLoadingState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Save Changes",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                schoolsCubit.updateSchoolProfile(
                                  name: fullNameController.text,
                                  description: descriptionController.text,
                                  phone: phoneController.text,
                                  address: locationController.text,
                                  establishmentDate:
                                      establishedInController.text,
                                  establishmentBy: establishedByController.text,
                                  website: websiteController.text,
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

  Future<void> _showPicker(BuildContext context) async {
    String formattedDate = '';
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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
