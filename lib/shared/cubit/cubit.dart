import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/new_Archive.dart';
import 'package:todo/modules/new_Done.dart';
import 'package:todo/modules/new_Tasks.dart';
import 'package:todo/shared/cubit/stats.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [NewTasks(), NewDone(), NewArchive()];

  List<String> titles = [
    "Tasks",
    "Done",
    "Archive",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

//createDataBase

  void createDataBase() {
    openDatabase('todo db', version: 1, onCreate: (database, version) {
      database
          .execute(
              "CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,data TEXT, time TEXT, status TEXT)")
          .then((value) {
        // ignore: avoid_print
        print("createDataBase Mohamed Saeed");
      }).catchError((error) {
        print("mohamed error ${error.toString()}");
      });
    }, onOpen: (database) {
      print('DatabaseOpen');
      getDataBase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

//insertDatabase

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, data, time ,status) VALUES("$title", "$date", "$time" , "new")')
          .then((value) {
        print("$value Done InsertDatabase ");
        emit(AppInsertDataBaseState());

        getDataBase(database);
      }).catchError((error) {
        print("mohamed error InsertDatabase ${error.toString()}");
      });
    });
  }

//getDataBase

  void getDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    database!.rawQuery('SELECT * FROM Tasks').then((value) {
      tasks = value;
      print(tasks);
      value.forEach((element) {
        print(element['status']);

        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateDataBase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status  = ? WHERE id = ?', [
      '$status',
      id,
    ]).then((value) {
      getDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteDataBase({
    required int id,
  }) async {
    database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      getDataBase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool showBottomSheet = false;
  IconData fabicon = Icons.edit;

  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    showBottomSheet = isShow;
    fabicon = icon;
    emit(AppChangeBottomSheetState());
  }
}
