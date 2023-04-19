import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../controller/layout/teachers/teacher_cubit.dart';
import '../../../core/style/app_color.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/app_textformfiled_widget.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class TeacherAttendanceScreen extends StatelessWidget {
  TeacherAttendanceScreen({super.key});
  TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {
          if (state is TeacherSchedulesAttendSuccessState) {
            Navigator.pop(context);
            showFlutterToast(
              message: "Attendance added successfully",
              toastColor: Colors.green,
            );
          }
        },
        builder: (context, state) {
          TeacherCubit teacherCubit = TeacherCubit.get(context);
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            image: AssetImage(AppImages.attendanceLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Date",
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
                        hintText: "Enter attendance date",
                        prefix: Icons.date_range,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter attendance date";
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSize.sv_20,
                    const Text(
                      "Status",
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
                          value: teacherCubit.studentStatus,
                          onChanged: (value) {
                            teacherCubit.changeStatus(status: value.toString());
                          },
                          items: teacherCubit.statusList.map((value) {
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
                    AppSize.sv_20,
                    state is TeacherSchedulesAttendLoadingState
                        ? const CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Add Attendance",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                teacherCubit.schedulesAttend(
                                  date: dateController.text,
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
