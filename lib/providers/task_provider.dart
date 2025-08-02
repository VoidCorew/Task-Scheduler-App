import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';

class TaskProvider extends ChangeNotifier {
  final List<SaveTask> _tasks = [];
  List<SaveTask> get tasks => _tasks;
  final List<SaveTask> _trashed = [];
  List<SaveTask> get trashed => _trashed;
  final List<SaveTask> _unsorted = [];
  List<SaveTask> get unsorted => _unsorted;

  late final Box<SaveTask> _taskBox;
  late final Box<SaveTask> _trashedBox;
  late final Box<SaveTask> _unsortedBox;

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<SaveTask>('tasks');
    _tasks.addAll(_taskBox.values);
    _trashedBox = Hive.box<SaveTask>('trashed');
    _trashed.addAll(_trashedBox.values);
    _unsortedBox = Hive.box<SaveTask>('unsorted');
    _unsorted.addAll(_unsortedBox.values);
    notifyListeners();
  }

  // Future<void> addTask(SaveTask task) async {
  //   final key = await _taskBox.add(task);
  //   // await _taskBox.add(task);
  //   _tasks.add(_taskBox.get(key)!);
  //   notifyListeners();
  // }

  // updated addTask
  Future<void> addTask(SaveTask task) async {
    // if (task.dateTime != null &&
    //     task.dateTime!.hour != 0 &&
    //     task.dateTime!.minute != 0) {
    //   final key = await _taskBox.add(task);
    //   _tasks.add(_taskBox.get(key)!);
    // } else {
    //   final key = _unsortedBox.add(task);
    //   _unsorted.add(_unsortedBox.get(key)!);
    // }
    if (task.hasDate && task.hasTime) {
      final key = await _taskBox.add(task);
      _tasks.add(_taskBox.get(key)!);
    } else {
      final key = await _unsortedBox.add(task);
      final unsorted = _unsortedBox.get(key);
      // _unsorted.add(unsorted!);
      if (unsorted != null) {
        _unsorted.add(unsorted);
      }
    }
    notifyListeners();
  }

  Future<void> deleteTask(SaveTask task) async {
    final copiedTask = SaveTask(
      task: task.task,
      dateTime: task.dateTime,
      note: task.note,
      isDone: task.isDone,
      hasDate: task.hasDate,
      hasTime: task.hasTime,
      origin: task.hasDate && task.hasTime ? 'tasks' : 'unsorted',
    );

    final trashedKey = await _trashedBox.add(copiedTask);
    final trashedTask = _trashedBox.get(trashedKey);
    if (trashedTask != null) {
      _trashed.add(trashedTask);
    }

    if (task.hasDate) {
      await _taskBox.delete(task.key);
      _tasks.remove(task);
    } else {
      await _unsortedBox.delete(task.key);
      _unsorted.remove(task);
    }
    notifyListeners();

    // final key = await _trashedBox.add(copiedTask);
    // _trashed.add(_trashedBox.get(key)!);

    // await _taskBox.delete(task.key);
    // _tasks.remove(task);
    // notifyListeners();
  }

  Future<void> restoreTask(SaveTask task) async {
    await _trashedBox.delete(task.key);
    _trashed.remove(task);
    if (task.origin == 'tasks') {
      final key = await _taskBox.add(task);
      _tasks.add(_taskBox.get(key)!);
    } else {
      final key = await _unsortedBox.add(task);
      _unsorted.add(_unsortedBox.get(key)!);
    }

    notifyListeners();
  }

  Future<void> deleteForever(SaveTask task) async {
    await _trashedBox.delete(task.key);
    _trashed.remove(task);
    notifyListeners();
  }

  Future<void> updateTask(SaveTask oldTask, SaveTask updatedTask) async {
    oldTask.task = updatedTask.task;
    oldTask.dateTime = updatedTask.dateTime;
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
      return task.dateTime?.year == day.year &&
          task.dateTime?.month == day.month &&
          task.dateTime?.day == day.day;
    }).toList();
  }
}
