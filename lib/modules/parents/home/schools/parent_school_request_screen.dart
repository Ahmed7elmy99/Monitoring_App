import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../widgets/show_flutter_toast.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../admin/widgets/save_changes_bottom.dart';
import '../../../widgets/const_widget.dart';

class ParentSchoolRequestScreen extends StatefulWidget {
  final String schoolId;
  ParentSchoolRequestScreen({super.key, required this.schoolId});

  @override
  State<ParentSchoolRequestScreen> createState() =>
      _ParentSchoolRequestScreenState();
}

class _ParentSchoolRequestScreenState extends State<ParentSchoolRequestScreen> {
  TextEditingController childIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ChildrenModel? selectedChild;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('School Request'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state is ParentAddRequestToSchoolSuccessState) {
            showFlutterToast(
              message: "Request sent successfully",
              toastColor: Colors.green,
            );
            Navigator.pop(context);
          }
          if (state is ParentAddRequestToSchoolErrorState) {
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
              padding: EdgeInsets.all(20.0),
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
                      "Child Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSize.sv_10,
                    parentCubit.parentChildrenList.isNotEmpty
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
                              items: parentCubit.parentChildrenList
                                  .map((child) => DropdownMenuItem(
                                        value: child,
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
                    state is ParentAddRequestToSchoolLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (selectedChild?.schoolId == 'requested' ||
                                    selectedChild?.schoolId == '') {
                                  parentCubit.addRequestToSchool(
                                    childModel: selectedChild!,
                                    schoolId: widget.schoolId,
                                  );
                                } else {
                                  showFlutterToast(
                                    message:
                                        "You have already sent a request to  school",
                                    toastColor: Colors.red,
                                  );
                                }
                              }
                            },
                            textBottom: "Send Request",
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
