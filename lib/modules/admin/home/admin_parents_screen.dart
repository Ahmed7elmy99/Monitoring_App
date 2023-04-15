import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/build_item_parent_widget.dart';

import '../../../controller/layout/admins/layout_cubit.dart';
import '../../../core/utils/app_size.dart';
import '../../../models/parent_model.dart';
import '../../widgets/const_widget.dart';

class AdminParentsScreen extends StatelessWidget {
  const AdminParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parents'),
      ),
      body: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          LayoutCubit layoutCubit = LayoutCubit.get(context);
          return state is AdminGetAllParentLoadingState
              ? CircularProgressComponent()
              : layoutCubit.parentList.isEmpty
                  ? Center(
                      child: Text(
                        'No Teachers',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        ParentModel item = layoutCubit.parentList[index];
                        return BuildItemParentWidget(model: item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: layoutCubit.parentList.length,
                    );
        },
      ),
    );
  }
}
