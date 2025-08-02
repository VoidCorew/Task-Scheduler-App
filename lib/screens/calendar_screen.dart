import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
import 'package:tasks_scheduler/providers/calendar_color_provider.dart';
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
    final colorProvider = context.watch<CalendarColorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь', style: TextStyle(fontFamily: 'Jost')),
        actions: [
          IconButton(
            onPressed: () {
              Color newTodayColor = colorProvider.todayColor;

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  title: const Text('Выберите цвет для сегодняшнего дня'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: newTodayColor,
                      onColorChanged: (Color color) {
                        newTodayColor = color;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        colorProvider.setTodayColor(newTodayColor);
                        Navigator.pop(context);
                      },
                      child: const Text('Выбрать'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.today),
          ),
          IconButton(
            onPressed: () {
              Color newSelectedColor = colorProvider.selectedDayColor;

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  title: const Text('Выберите цвет для выбранного дня'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: newSelectedColor,
                      onColorChanged: (Color color) {
                        newSelectedColor = color;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        colorProvider.setSelectedDayColor(newSelectedColor);
                        Navigator.pop(context);
                      },
                      child: const Text('Выбрать'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              eventLoader: (day) {
                return taskProvider.getTasksForToday(day);
              },
              locale: "ru_RU",
              rowHeight: 43,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.utc(2019, 10, 18),
              lastDay: DateTime.utc(2030, 4, 20),
              pageAnimationDuration: Duration(milliseconds: 400),
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                outsideTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                todayTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                selectedTextStyle: TextStyle(
                  fontFamily: 'Monsterrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(
                  color: colorProvider.todayColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorProvider.selectedDayColor,
                  shape: BoxShape.circle,
                ),
              ),
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
                                ).format(task.dateTime!),
                                style: TextStyle(fontFamily: 'Monsterrat'),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  taskProvider.deleteTask(task);
                                },
                                icon: Icon(Icons.delete),
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
                                ).format(task.dateTime!),
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
      ),
    );
  }
}
