import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';

class TaskProvider extends ChangeNotifier {
  final List<SaveTask> _tasks = [];
  List<SaveTask> get tasks => _tasks;
  final List<SaveTask> _trashed = [];
  List<SaveTask> get trashed => _trashed;

  late final Box<SaveTask> _taskBox;
  late final Box<SaveTask> _trashedBox;

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<SaveTask>('tasks');
    _tasks.addAll(_taskBox.values);
    _trashedBox = Hive.box<SaveTask>('trashed');
    _trashed.addAll(_trashedBox.values);
    notifyListeners();
  }

  Future<void> addTask(SaveTask task) async {
    final key = await _taskBox.add(task);
    // await _taskBox.add(task);
    _tasks.add(_taskBox.get(key)!);
    notifyListeners();
  }

  Future<void> deleteTask(SaveTask task) async {
    final copiedTask = SaveTask(
      task: task.task,
      time: task.time,
      note: task.note,
    );

    final key = await _trashedBox.add(copiedTask);
    _trashed.add(_trashedBox.get(key)!);

    await _taskBox.delete(task.key);
    _tasks.remove(task);
    notifyListeners();
  }

  Future<void> restoreTask(SaveTask task) async {
    await _trashedBox.delete(task.key);
    _trashed.remove(task);
    final key = await _taskBox.add(task);
    _tasks.add(_taskBox.get(key)!);
    notifyListeners();
  }

  Future<void> deleteForever(SaveTask task) async {
    await _trashedBox.delete(task.key);
    _trashed.remove(task);
    notifyListeners();
  }

  Future<void> updateTask(SaveTask oldTask, SaveTask updatedTask) async {
    oldTask.task = updatedTask.task;
    oldTask.time = updatedTask.time;
    oldTask.note = updatedTask.note;

    // oldTask
    //   ..task = updatedTask.task
    //   ..time = updatedTask.time
    //   ..note = updatedTask.note
    //   ..isDone = updatedTask.isDone;

    await oldTask.save();
    notifyListeners();
  }

  Future<void> toggleTaskDone(SaveTask task, bool isDone) async {
    task.isDone = isDone;
    await task.save();
    notifyListeners();
  }

  List<SaveTask> getTasksForToday(DateTime day) {
    return _tasks.where((task) {
      return task.time.year == day.year &&
          task.time.month == day.month &&
          task.time.day == day.day;
    }).toList();
  }
}
