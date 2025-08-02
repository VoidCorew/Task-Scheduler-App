import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'save_calendar_color.g.dart';

@HiveType(typeId: 1)
class SaveCalendarColor extends HiveObject {
  @HiveField(0)
  int todayColorValue;

  @HiveField(1)
  int selectedDayColorValue;

  SaveCalendarColor({
    required this.todayColorValue,
    required this.selectedDayColorValue,
  });

  Color get todayColor => Color(todayColorValue);
  Color get selectedDayColor => Color(selectedDayColorValue);

  set todayColor(Color color) => todayColorValue = color.toARGB32();
  set selectedDayColor(Color color) => selectedDayColorValue = color.toARGB32();
}
