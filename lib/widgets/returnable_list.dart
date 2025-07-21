import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';

Widget returnableTile(
  BuildContext context,
  TaskProvider taskProvider,
  int index,
) {
  final trash = taskProvider.trashed[index];
  if (trash.note == null) {
    if (Platform.isWindows) {
      return ListTile(
        leading: const Icon(Icons.task),
        title: Text(trash.task, style: TextStyle(fontFamily: 'Monsterrat')),
        subtitle: Text(
          DateFormat('yyyy-MM-dd HH:mm').format(trash.time),
          style: TextStyle(fontFamily: 'Monsterrat'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                taskProvider.restoreTask(trash);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Задача восстановлена',
                      style: TextStyle(fontFamily: 'Monsterrat'),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.restore),
            ),
            IconButton(
              onPressed: () {
                taskProvider.deleteForever(trash);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Задача удалена навсегда',
                      style: TextStyle(fontFamily: 'Monsterrat'),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      );
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              taskProvider.restoreTask(trash);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Задача восстановлена',
                    style: TextStyle(fontFamily: 'Monsterrat'),
                  ),
                ),
              );
            },
            icon: Icons.restore,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          SlidableAction(
            onPressed: (context) {
              taskProvider.deleteForever(trash);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Задача удалена навсегда',
                    style: TextStyle(fontFamily: 'Monsterrat'),
                  ),
                ),
              );
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.task),
        title: Text(trash.task, style: TextStyle(fontFamily: 'Monsterrat')),
        subtitle: Text(
          DateFormat('yyyy-MM-dd HH:mm').format(trash.time),
          style: TextStyle(fontFamily: 'Monsterrat'),
        ),
      ),
    );
  }
  if (Platform.isWindows) {
    return ExpansionTile(
      leading: const Icon(Icons.task),
      title: Text(trash.task, style: TextStyle(fontFamily: 'Monsterrat')),
      subtitle: Text(
        DateFormat('yyyy-MM-dd HH:mm').format(trash.time),
        style: TextStyle(fontFamily: 'Monsterrat'),
      ),
      children: <Widget>[
        ListTile(
          title: Text(trash.note!, style: TextStyle(fontFamily: 'Monsterrat')),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  taskProvider.restoreTask(trash);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Задача восстановлена',
                        style: TextStyle(fontFamily: 'Monsterrat'),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.restore),
              ),
              IconButton(
                onPressed: () {
                  taskProvider.deleteForever(trash);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Задача удалена навсегда',
                        style: TextStyle(fontFamily: 'Monsterrat'),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ],
    );
  }
  return Slidable(
    endActionPane: ActionPane(
      motion: StretchMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            taskProvider.restoreTask(trash);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Задача восстановлена',
                  style: TextStyle(fontFamily: 'Monsterrat'),
                ),
              ),
            );
          },
          icon: Icons.restore,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        SlidableAction(
          onPressed: (context) {
            taskProvider.deleteForever(trash);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Задача удалена навсегда',
                  style: TextStyle(fontFamily: 'Monsterrat'),
                ),
              ),
            );
          },
          icon: Icons.delete,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ],
    ),
    child: ExpansionTile(
      leading: const Icon(Icons.task),
      title: Text(trash.task, style: TextStyle(fontFamily: 'Monsterrat')),
      subtitle: Text(
        DateFormat('yyyy-MM-dd HH:mm').format(trash.time),
        style: TextStyle(fontFamily: 'Monsterrat'),
      ),
      children: <Widget>[
        ListTile(
          title: Text(trash.note!, style: TextStyle(fontFamily: 'Monsterrat')),
        ),
      ],
    ),
  );
}
