import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDB(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, TodoStates state) {
          if (state is TodoInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, TodoStates state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.numberOfTap],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDB(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                    titleController.text = "";
                    timeController.text = "";
                    dateController.text = "";

                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 15.0,
                        (context) => Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                tff(
                                    label: "Task Title",
                                    controller: titleController,
                                    prefixIcon: const Icon(Icons.title),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Title must not be empty";
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 15.0),
                                tff(
                                    label: "Task Time",
                                    controller: timeController,
                                    textType: TextInputType.none,
                                    prefixIcon:
                                        const Icon(Icons.timer_outlined),
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Time must not be empty";
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 15.0),
                                tff(
                                    label: "Task Date",
                                    controller: dateController,
                                    textType: TextInputType.none,
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2024-10-25"))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Date must not be empty";
                                      }
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.numberOfTap,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "archive"),
                ]),
            body: cubit.screens[cubit.numberOfTap]
          );
        },
      ),
    );
  }
}
