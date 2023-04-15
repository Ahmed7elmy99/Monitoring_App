import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'parent_children_details.dart';

import '../../../../controller/layout/parents/parent_cubit.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/screen_config.dart';
import '../../../../models/children_model.dart';
import '../../../widgets/const_widget.dart';

class ParentChildrenScreen extends StatelessWidget {
  const ParentChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
      ),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {},
        builder: (context, state) {
          ParentCubit parentCubit = ParentCubit.get(context);
          return state is ParentGetAllChildrenLoadingState
              ? CircularProgressComponent()
              : parentCubit.parentChildrenList.isEmpty
                  ? Center(
                      child: Text(
                        'No Children',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        ChildrenModel item =
                            parentCubit.parentChildrenList[index];
                        return _buildItemList(context, item);
                      },
                      separatorBuilder: (context, index) => AppSize.sv_10,
                      itemCount: parentCubit.parentChildrenList.length,
                    );
        },
      ),
    );
  }

  Widget _buildItemList(BuildContext context, ChildrenModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentChildrenDetailsScreen(
              childrenModel: item,
            ),
          ),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.24,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: item.id,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('${item.image}'),
              ),
            ),
            AppSize.sh_10,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.grey,
                      ),
                      AppSize.sh_5,
                      Expanded(
                        child: Text(
                          item.educationLevel,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSize.sv_2,
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                      AppSize.sh_5,
                      Text(
                        item.age.toString() + ' years old',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
