import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teatcher_app/modules/schools/home/widgets/build_supervisor_item.dart';

import '../../../controller/layout/schools/schools_cubit.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/screen_config.dart';
import '../../../models/supervisors_model.dart';
import '../../widgets/const_widget.dart';

class SchoolSupervisorScreen extends StatefulWidget {
  const SchoolSupervisorScreen({super.key});

  @override
  State<SchoolSupervisorScreen> createState() => _SchoolSupervisorScreenState();
}

class _SchoolSupervisorScreenState extends State<SchoolSupervisorScreen> {
  TextEditingController banController = TextEditingController();
  bool supervisorIsBan = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisors'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routers.ADD_SCHOOL_SUPERVISOR,
              );
            },
            icon: Icon(
              Icons.edit_square,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ],
      ),
      body: BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {},
        builder: (context, state) {
          SchoolsCubit schoolsCubit = SchoolsCubit.get(context);
          return state is SchoolsGetAllSupervisorsLoadingState
              ? CircularProgressComponent()
              : schoolsCubit.schoolsSupervisorsList.isEmpty
                  ? Center(
                      child: Text(
                      'No Supervisors',
                      style: GoogleFonts.almarai(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      itemBuilder: (context, index) {
                        SupervisorsModel item =
                            schoolsCubit.schoolsSupervisorsList[index];
                        return BuildSupervisorItem(model: item);
                      },
                      itemCount: schoolsCubit.schoolsSupervisorsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    );
        },
      ),
    );
  }
}
