import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
import 'package:tasks_scheduler/providers/buttons_provider.dart';
// import 'package:tasks_scheduler/models/task.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';
import 'package:tasks_scheduler/providers/theme_provider.dart';
import 'package:tasks_scheduler/screens/calendar_screen.dart';
import 'package:tasks_scheduler/screens/create_task_screen.dart';
import 'package:tasks_scheduler/screens/settings_screen.dart';
import 'package:tasks_scheduler/screens/trash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Task> _tasks = [];
  // bool _value = false;

  // timeofday as datetime

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final taskProvider = context.watch<TaskProvider>();
    // final tasks = taskProvider.tasks;
    final unsorted = taskProvider.unsorted;
    final buttonsProvider = context.watch<ButtonsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная', style: TextStyle(fontFamily: 'Jost')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => TrashScreen()),
              );
            },
            icon: Icon(Icons.delete_outline_rounded),
          ),
          // IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          Switch(
            value: themeProvider.isDark,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
            },
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
              if (states.contains(WidgetState.selected)) {
                return Icon(Icons.nights_stay, color: Colors.white, size: 20);
              }
              return Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 20);
            }),
            activeColor: Colors.white30,
            activeTrackColor: Colors.indigo[900],
          ),
          // const SizedBox(width: 10),
          if (!buttonsProvider.showButtons)
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Календарь'),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CalendarScreen(),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text('Добавить задачу'),
                  onTap: () async {
                    final SaveTask? task = await Navigator.push<SaveTask?>(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CreateTaskScreen(),
                      ),
                    );

                    if (task != null) {
                      taskProvider.addTask(task);
                    }
                  },
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Ваши задачи',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontFamily: 'Monsterrat'),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: unsorted.isEmpty
                ? const Center(
                    child: Text(
                      'Ваш список пуст',
                      style: TextStyle(fontFamily: 'Monsterrat'),
                    ),
                  )
                : ListView.builder(
                    itemCount: unsorted.length,
                    itemBuilder: (context, index) {
                      final task = unsorted[index];
                      if (task.note == null) {
                        if (Platform.isWindows) {
                          return ListTile(
                            tileColor: task.isDone == true
                                ? themeProvider.isDark
                                      ? Colors.white10
                                      : Colors.black12
                                : null,
                            leading: Checkbox(
                              value: task.isDone ?? false,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  // setState(() => _value = value);
                                  taskProvider.toggleTaskDone(task, value);
                                }
                              },
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final SaveTask? updatedTask =
                                          await Navigator.push<SaveTask?>(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  CreateTaskScreen(task: task),
                                            ),
                                          );

                                      if (updatedTask != null) {
                                        // setState(() {
                                        //   _tasks[index] = updatedTask;
                                        // });
                                        taskProvider.updateTask(
                                          task,
                                          updatedTask,
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      taskProvider.deleteTask(task);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                            // leading: const Icon(Icons.task),
                            title: Text(
                              task.task,
                              style: TextStyle(
                                decoration: task.isDone == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontFamily: 'Monsterrat',
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(task.dateTime!),
                              style: TextStyle(fontFamily: 'Monsterrat'),
                            ),
                          );
                        }
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final SaveTask? updatedTask =
                                      await Navigator.push<SaveTask?>(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              CreateTaskScreen(task: task),
                                        ),
                                      );

                                  if (updatedTask != null) {
                                    taskProvider.updateTask(task, updatedTask);
                                  }
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  taskProvider.deleteTask(task);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Задача перемещена в корзину',
                                        style: TextStyle(
                                          fontFamily: 'Monsterrat',
                                        ),
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
                            tileColor: task.isDone == true
                                ? themeProvider.isDark
                                      ? Colors.white10
                                      : Colors.black12
                                : null,
                            leading: Checkbox(
                              value: task.isDone ?? false,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  // setState(() => _value = value);
                                  taskProvider.toggleTaskDone(task, value);
                                }
                              },
                            ),
                            // leading: const Icon(Icons.task),
                            title: Text(
                              task.task,
                              style: TextStyle(
                                decoration: task.isDone == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontFamily: 'Monsterrat',
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(task.dateTime!),
                              style: TextStyle(fontFamily: 'Monsterrat'),
                            ),
                          ),
                        );
                      }
                      if (Platform.isWindows) {
                        return ExpansionTile(
                          // leading: const Icon(Icons.task),
                          backgroundColor: task.isDone == true
                              ? themeProvider.isDark
                                    ? Colors.white10
                                    : Colors.black12
                              : null,
                          collapsedBackgroundColor: task.isDone == true
                              ? themeProvider.isDark
                                    ? Colors.white10
                                    : Colors.black12
                              : null,
                          leading: Checkbox(
                            value: task.isDone ?? false,
                            onChanged: (bool? value) {
                              if (value != null) {
                                // setState(() => _value = value);
                                taskProvider.toggleTaskDone(task, value);
                              }
                            },
                          ),
                          title: Text(
                            task.task,
                            style: TextStyle(
                              decoration: task.isDone == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontFamily: 'Monsterrat',
                            ),
                          ),
                          subtitle: Text(
                            DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(task.dateTime!),
                            style: TextStyle(fontFamily: 'Monsterrat'),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                task.note!,
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final SaveTask? updatedTask =
                                            await Navigator.push<SaveTask?>(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    CreateTaskScreen(
                                                      task: task,
                                                    ),
                                              ),
                                            );

                                        if (updatedTask != null) {
                                          // setState(() {
                                          //   _tasks[index] = updatedTask;
                                          // });
                                          taskProvider.updateTask(
                                            task,
                                            updatedTask,
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        taskProvider.deleteTask(task);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Задача перемещена в корзину',
                                              style: TextStyle(
                                                fontFamily: 'Monsterrat',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
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
                              onPressed: (context) async {
                                final SaveTask? updatedTask =
                                    await Navigator.push<SaveTask?>(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            CreateTaskScreen(task: task),
                                      ),
                                    );

                                if (updatedTask != null) {
                                  taskProvider.updateTask(task, updatedTask);
                                }
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.white,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                taskProvider.deleteTask(task);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          // leading: const Icon(Icons.task),
                          backgroundColor: task.isDone == true
                              ? themeProvider.isDark
                                    ? Colors.white10
                                    : Colors.black12
                              : null,
                          collapsedBackgroundColor: task.isDone == true
                              ? themeProvider.isDark
                                    ? Colors.white10
                                    : Colors.black12
                              : null,
                          leading: Checkbox(
                            value: task.isDone ?? false,
                            onChanged: (bool? value) {
                              if (value != null) {
                                // setState(() => _value = value);
                                taskProvider.toggleTaskDone(task, value);
                              }
                            },
                          ),
                          title: Text(
                            task.task,
                            style: TextStyle(
                              decoration: task.isDone == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontFamily: 'Monsterrat',
                            ),
                          ),
                          subtitle: Text(
                            DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(task.dateTime!),
                            style: TextStyle(fontFamily: 'Monsterrat'),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                task.note!,
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: buttonsProvider.showButtons
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'calendar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CalendarScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.calendar_month_rounded),
                ),
                const SizedBox(height: 15),
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () async {
                    final SaveTask? task = await Navigator.push<SaveTask?>(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CreateTaskScreen(),
                      ),
                    );

                    if (task != null) {
                      // setState(() {
                      //   _tasks.add(task);
                      // });
                      taskProvider.addTask(task);
                    }
                  },
                  child: Icon(Icons.add_rounded),
                ),
              ],
            )
          : null,
    );
  }
}
