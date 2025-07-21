import 'package:hive/hive.dart';

part 'save_task.g.dart';

@HiveType(typeId: 0)
class SaveTask extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime time;

  @HiveField(2)
  String? note;

  @HiveField(3)
  bool? isDone;

  SaveTask({
    required this.task,
    required this.time,
    this.note,
    this.isDone = false,
  });
}
