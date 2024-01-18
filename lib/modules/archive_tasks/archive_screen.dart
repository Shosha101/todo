import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).archiveTasks;
        return tasks.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return model(tasks[index], context);
                },
                separatorBuilder: (context, index) => Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                itemCount: tasks.length)
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.archive,
                      size: 100.0,
                      color: Colors.grey,
                    ),
                    Text("No Archive Yet, Put Some Archive",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              );
      },
    );
  }
}
