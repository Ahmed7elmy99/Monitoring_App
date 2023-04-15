import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/const_data.dart';

import '../../../controller/layout/parents/parent_cubit.dart';
import '../../../core/style/icon_broken.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/screen_config.dart';
import '../../admin/widgets/app_textformfiled_widget.dart';
import '../../admin/widgets/save_changes_bottom.dart';
import '../../widgets/const_widget.dart';

class EditParentProfileScreen extends StatefulWidget {
  const EditParentProfileScreen({super.key});

  @override
  State<EditParentProfileScreen> createState() =>
      _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController.text = PARENT_MODEL!.name;
    phoneController.text = PARENT_MODEL!.phone;
    ageController.text = PARENT_MODEL!.age;
    genderController.text = PARENT_MODEL!.gender;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
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
                                image: parentCubit.parentImageFile == null
                                    ? NetworkImage(
                                        PARENT_MODEL!.image,
                                      )
                                    : FileImage(parentCubit.parentImageFile!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              parentCubit.updateParentProfileImage(
                                  userId: PARENT_MODEL!.id);
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
                                controller: ageController,
                                hintText: "Enter your age",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter your age";
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
                                controller: genderController,
                                hintText: "Enter your gender",
                                prefix: Icons.person,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter your gender";
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
                    state is ParentUpdateProfileImageLoadingState
                        ? CircularProgressComponent()
                        : SaveChangesBottom(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                parentCubit.updateParentProfileData(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  age: ageController.text,
                                  gender: genderController.text,
                                );
                              }
                            },
                            textBottom: 'Save Changes',
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
