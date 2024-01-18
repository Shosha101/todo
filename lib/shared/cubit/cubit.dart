import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_tasks/archive_screen.dart';
import 'package:todo_app/modules/done_tasks/done_screen.dart';
import 'package:todo_app/modules/new_tasks/tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int numberOfTap = 0;

  Database? db;

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen()
  ];

  List<String> titles = ["New Tasks", "Done Tasks", "Archive Tasks"];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDB() {
    openDatabase("todo.db", version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
    }, onOpen: (db) {
      getDB(db);
    }).then((value) {
      db = value;
      emit(TodoCreateDatabaseState());
    });
  }

  insertToDB(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await db!.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
            .then((value) {
          getDB(db);
          emit(TodoInsertDatabaseState());
        }));
  }

  void getDB(db) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    db!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(TodoGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    db!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDB(db);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteData({required int id}) async {
    db!.rawUpdate(
        'DELETE FROM tasks WHERE id = ?',[id]).then((value) {
      getDB(db);
      emit(TodoDeleteDatabaseState());
    });
  }

//------------------------------------------------------------------------------
  void changeIndex(int index) {
    numberOfTap = index;
    emit(TodoChangeBottomNavBarState());
  }

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(TodoChangeBottomSheetState());
  }
}
