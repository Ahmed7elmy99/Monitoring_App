import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../models/attend_model.dart';

class ParentChildrenAttendScreen extends StatelessWidget {
  const ParentChildrenAttendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Children Attendance'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return parentCubit.parentAttendList.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    AttendModel item = parentCubit.parentAttendList[index];
                    return _buildAttendanceItemWidget(context, model: item);
                  },
                  separatorBuilder: (context, index) => AppSize.sv_10,
                  itemCount: parentCubit.parentAttendList.length,
                )
              : Center(
                  child: Text(
                    'No Attendance Found  !!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildAttendanceItemWidget(BuildContext context,
      {required AttendModel model}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.grey.withOpacity(0.2),
              backgroundImage: AssetImage(AppImages.attendanceIcon),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.status,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 18,
                        color: Colors.teal.withOpacity(0.8),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        model.date,
                        style: GoogleFonts.almarai(
                          height: 1.5,
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
