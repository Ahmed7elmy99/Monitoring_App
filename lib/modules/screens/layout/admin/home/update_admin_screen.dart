import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teatcher_app/controller/layout/layout_cubit.dart';

import '../../../../../core/style/icon_broken.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/screen_config.dart';
import '../../../../../models/admin_models.dart';
import '../../../../widgets/const_widget.dart';
import '../widgets/app_textformfiled_widget.dart';
import '../widgets/save_changes_bottom.dart';

class AdminUpdateScreen extends StatefulWidget {
  final AdminModels adminModels;
  const AdminUpdateScreen({
    super.key,
    required this.adminModels,
  });

  @override
  State<AdminUpdateScreen> createState() => _AdminUpdateScreenState();
}

class _AdminUpdateScreenState extends State<AdminUpdateScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController genderController = TextEditingController();
  TextEditingController banController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _value = 'male';
  String _banValue = 'true';
  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.adminModels.name;
    emailController.text = widget.adminModels.email;
    passwordController.text = widget.adminModels.password!;
    phoneController.text = widget.adminModels.phone;
    genderController.text = widget.adminModels.gender;
    banController.text = widget.adminModels.ban!;
    _value = widget.adminModels.gender;
    _banValue = widget.adminModels.ban!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Admin Screen'),
        ),
        body: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {
            if (state is LayoutUpdateAdminsDataErrorState) {
              Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            if (state is LayoutUpdateAdminsDataSuccessState) {
              Fluttertoast.showToast(
                msg: 'Admin Updated Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            LayoutCubit layoutCubit = LayoutCubit.get(context);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
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
                                          widget.adminModels.image ??
                                              AppImages.defaultImage,
                                        )
                                      : FileImage(layoutCubit.uploadImageFile!)
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => layoutCubit.updateAdminsImages(
                                  userModel: widget.adminModels),
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
                      AppSize.sv_20,
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
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email",
                        prefix: Icons.email_rounded,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Email";
                          }
                          if (!value.contains('@')) {
                            return "Please Enter Valid Email";
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
                          if (value!.isEmpty) {
                            return "Please Enter Phone";
                          }
                          return null;
                        },
                      ),
                      AppSize.sv_20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  AppSize.sv_10,
                                  DropdownButton<String>(
                                    items: <String>[
                                      'male',
                                      'female',
                                    ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    value: _value,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 20.0,
                                    ),
                                    elevation: 16,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                    underline: Container(
                                      height: 0,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _value = newValue!;
                                        genderController.text = _value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSize.sh_20,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Ban",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                DropdownButton<String>(
                                  items: <String>[
                                    'true',
                                    'false',
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  value: _banValue,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 20.0,
                                  ),
                                  elevation: 16,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _banValue = newValue!;
                                      banController.text = _banValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      AppSize.sv_20,
                      state is LayoutCreateAdminAccountLoadingState
                          ? const CircularProgressComponent()
                          : SaveChangesBottom(
                              textBottom: "Add Admin",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  layoutCubit.updateAdminsData(
                                    AdminModels(
                                      id: widget.adminModels.id,
                                      name: fullNameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      gender: genderController.text,
                                      ban: banController.text,
                                      createdAt: widget.adminModels.createdAt,
                                      password: widget.adminModels.password,
                                      image: widget.adminModels.image,
                                    ),
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
        ));
  }
}
