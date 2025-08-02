import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'save_task.g.dart';

@HiveType(typeId: 0)
class SaveTask extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime? dateTime;

  @HiveField(2)
  String? note;

  @HiveField(3)
  bool? isDone;

  @HiveField(4)
  bool hasDate;

  @HiveField(5)
  bool hasTime;

  @HiveField(6)
  String origin;

  SaveTask({
    required this.task,
    this.dateTime,
    this.note,
    this.isDone = false,
    required this.hasDate,
    required this.hasTime,
    this.origin = 'tasks',
  });
}
