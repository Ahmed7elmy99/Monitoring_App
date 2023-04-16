import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/children_model.dart';
import '../../../models/class_model.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/show_flutter_toast.dart';

class AddChildrenToClass extends StatefulWidget {
  const AddChildrenToClass({super.key});

  @override
  State<AddChildrenToClass> createState() => _AddChildrenToClassState();
}

class _AddChildrenToClassState extends State<AddChildrenToClass> {
  TextEditingController childIdController = TextEditingController();
  TextEditingController classIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ChildrenModel? selectedChild;
  ClassModel? selectedClass;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Children To Class'),
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          if (state is SchoolsAddChildrenToClassSuccessState) {
            showFlutterToast(
              message: 'Children Added Successfully',
              toastColor: Colors.green,
            );
          }
          if (state is SchoolsAddChildrenToClassErrorState) {
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
                    if (schoolsCubit.schoolsChildrenNotInClassList.isNotEmpty)
                      const Text(
                        "Child Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    AppSize.sv_10,
                    schoolsCubit.schoolsChildrenNotInClassList.isNotEmpty
                        ? Container(
                            width: SizeConfig.screenWidth * 0.4,
                            height: SizeConfig.screenHeight * 0.06,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: DropdownButton<ChildrenModel>(
                              value: selectedChild,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              items: schoolsCubit.schoolsChildrenNotInClassList
                                  .map((child) => DropdownMenuItem(
                                        value: child,
                                        key: ValueKey(child.id),
                                        child: Text(child.name),
                                      ))
                                  .toList(),
                              onChanged: (child) {
                                setState(() {
                                  selectedChild = child;
                                  childIdController.text = child!.name;
                                });
                              },
                            ),
                          )
                        : Container(),
                    AppSize.sv_20,
                    const Text(
                      "Class Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    schoolsCubit.schoolsClassesList.isNotEmpty
                        ? Container(
                            width: SizeConfig.screenWidth * 0.4,
                            height: SizeConfig.screenHeight * 0.06,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: DropdownButton<ClassModel>(
                              value: selectedClass,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              items: schoolsCubit.schoolsClassesList
                                  .map((child) => DropdownMenuItem(
                                        value: child,
                                        child: Text(child.name),
                                      ))
                                  .toList(),
                              onChanged: (child) {
                                setState(() {
                                  selectedClass = child;
                                  classIdController.text = child!.name;
                                });
                              },
                            ),
                          )
                        : Container(),
                    AppSize.sv_20,
                    state is SchoolsAddChildrenToClassLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            textBottom: "Create Class",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (selectedChild?.id != null &&
                                    selectedClass?.id != null) {
                                  schoolsCubit.addChildrenToClass(
                                    childrenModel: selectedChild!,
                                    classId: selectedClass!.id,
                                  );
                                } else {
                                  showFlutterToast(
                                    message: 'Please Select Child And Class',
                                    toastColor: Colors.red,
                                  );
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
}
