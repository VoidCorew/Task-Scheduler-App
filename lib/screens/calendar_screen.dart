import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';
import 'package:tasks_scheduler/screens/create_task_screen.dart';
// import 'package:tasks_scheduler/widgets/returnable_list.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<SaveTask> taskData = [];
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final todayTasks = taskProvider.getTasksForToday(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь', style: TextStyle(fontFamily: 'Jost')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              locale: "ru_RU",
              rowHeight: 43,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.utc(2019, 10, 18),
              lastDay: DateTime.utc(2030, 4, 20),
              pageAnimationDuration: Duration(milliseconds: 400),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 20),
            Text(
              'Ваши задачи за ${DateFormat('yyyy-MM-dd').format(today)}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontFamily: 'Monsterrat'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: todayTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Нет данных за этот день',
                        style: TextStyle(fontFamily: 'Monsterrat'),
                      ),
                    )
                  : ListView.builder(
                      itemCount: todayTasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];
                        if (task.note == null) {
                          if (Platform.isWindows) {
                            return ListTile(
                              leading: const Icon(Icons.task),
                              title: Text(
                                task.task,
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                ).format(task.time),
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                            );
                          }
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
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
                              leading: const Icon(Icons.task),
                              title: Text(
                                task.task,
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                ).format(task.time),
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                            ),
                          );
                        }
                        if (Platform.isWindows) {
                          return ExpansionTile(
                            leading: const Icon(Icons.task),
                            title: Text(
                              task.task,
                              style: TextStyle(fontFamily: 'Monsterrat'),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(task.time),
                              style: TextStyle(fontFamily: 'Monsterrat'),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  task.note!,
                                  style: TextStyle(fontFamily: 'Monsterrat'),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    taskProvider.deleteTask(task);
                                  },
                                  icon: Icon(Icons.delete),
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
                          child: ExpansionTile(
                            leading: const Icon(Icons.task),
                            title: Text(
                              task.task,
                              style: TextStyle(fontFamily: 'Monsterrat'),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(task.time),
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
      ),
    );
  }
}
