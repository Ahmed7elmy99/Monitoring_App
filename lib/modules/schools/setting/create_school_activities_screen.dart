import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/style/app_color.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class CreateSchoolActivitiesScreen extends StatelessWidget {
  CreateSchoolActivitiesScreen({super.key});
  TextEditingController fullNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create School Activity'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsAddActivitySuccessState) {
            showFlutterToast(
              message: "School added successfully",
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is SchoolsAddActivityErrorState) {
            showFlutterToast(message: state.error, toastColor: Colors.red);
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
                      "Name",
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
                      hintText: "Enter description of the activity",
                      prefix: Icons.location_on,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter description of the activity";
                        }
                        return null;
                      },
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Date of Activity",
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
                        controller: dateController,
                        keyboardType: TextInputType.text,
                        hintText: "Enter date of activity",
                        prefix: Icons.date_range,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter date of activity";
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSize.sv_20,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AppSize.sv_10,
                              AppTextFormFiledWidget(
                                keyboardType: TextInputType.number,
                                controller: priceController,
                                hintText: "Enter your price",
                                prefix: Icons.monetization_on,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter your price";
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
                                "Discount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AppSize.sv_10,
                              AppTextFormFiledWidget(
                                keyboardType: TextInputType.number,
                                controller: discountController,
                                hintText: "Enter discount of the activity",
                                prefix: Icons.discount,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter discount of the activity";
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
                    state is SchoolsAddActivityLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Create Activity",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                schoolsCubit.createActivityInSchool(
                                  activityName: fullNameController.text,
                                  activityDescription:
                                      descriptionController.text,
                                  activityDate: dateController.text,
                                  activityPrice: priceController.text,
                                  activityDiscount: discountController.text,
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

  Future<void> _showPicker(BuildContext context) async {
    String formattedDate = '';
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
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
      formattedDate = DateFormat.yMMMMEEEEd().format(pickedDate);
      dateController.text = formattedDate;
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
    } else {}
  }
}
