import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/defuld_form_fild.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/stats.dart';

class HomePage extends StatelessWidget {
// ignore: non_constant_identifier_names
  var Scaffoldkey = GlobalKey<ScaffoldState>();
  var valid = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDataBase(),
        child: BlocConsumer<AppCubit, AppState>(
          listener: (BuildContext context, AppState state) {
            if(state is AppInsertDataBaseState){
              Navigator.pop(context);
            }

          },
          builder: (BuildContext context, AppState state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              key: Scaffoldkey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: cubit.tasks.isEmpty
                  ? const Center(
                      child: Text('No Tasks',style: TextStyle(fontSize: 18 , color:Colors.grey),),
              )
                  : cubit.screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.showBottomSheet) {
                    if (valid.currentState!.validate()) {
                      cubit.insertDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                      // insertDatabase(
                      //title: titleController.text,
                      // time: timeController.text,
                      // date: dateController.text)
                      // .then((value) {
                      //Navigator.pop(context);

                      //cubit.showBottomSheet = false;

                      // setState(() {
                      // fabicon = Icons.edit;
                      //});

                      //});
                    }
                  } else {
                    Scaffoldkey.currentState!
                        .showBottomSheet(elevation: 30.0, (context) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: valid,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefuldFormFild(
                                    controller: titleController,
                                    hint: 'Task Title',
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title must not be Empty';
                                      }
                                      return null;
                                    },
                                    iconData: Icons.title,
                                    keyboardType: TextInputType.text,
                                    tab: () {},
                                    labeltext: 'Task Title',
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DefuldFormFild(
                                    controller: timeController,
                                    hint: 'Task Time',
                                    iconData: Icons.watch_later_outlined,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'time must not be Empty';
                                      }
                                      return null;
                                    },
                                    tab: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    labeltext: 'Task Time',
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DefuldFormFild(
                                    controller: dateController,
                                    hint: 'Task Data',
                                    iconData: Icons.date_range_outlined,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'time must not be Empty';
                                      }
                                      return null;
                                    },
                                    tab: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.parse('2060-05-15'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    labeltext: 'Task Data',
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.ChangeBottomSheetState(
                              isShow: false, icon: Icons.edit);
                        });
                    cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(
                  cubit.fabicon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archive',
                    )
                  ]),
            );
          },
        ));
  }
}
