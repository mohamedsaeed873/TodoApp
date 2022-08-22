import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/custom_newTasks.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/stats.dart';

class NewArchive extends StatelessWidget {
  const NewArchive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archiveTasks;

        return ListView.separated(
          itemBuilder: ((context, index) {
            return NewTask(
              model: tasks[index],
            );
          }),
          separatorBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.white,
              ),
            );
          }),
          itemCount: tasks.length,
        );
      },

    );
  }
}