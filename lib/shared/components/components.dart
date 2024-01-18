import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget tff({
  TextInputType textType = TextInputType.text,
  TextEditingController? controller,
  Icon? prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  bool isClickable = true,
  @required String? label,
  validator,
  onPressed,
  onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textType,
      obscureText: isPassword,
      validator: validator,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(suffixIcon, color: Colors.blue),
        ),
      ),
    );

Widget model(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${model['title']}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 10.0),
                  Text('${model['date']}',
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            IconButton(
                onPressed: () {
                  TodoCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  TodoCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(Icons.architecture, color: Colors.black45)),
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.get(context).deleteData(id: model['id']);
      },
    );
