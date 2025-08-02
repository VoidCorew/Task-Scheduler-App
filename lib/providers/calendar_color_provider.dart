import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_scheduler/hive_models/save_calendar_color.dart';

class CalendarColorProvider extends ChangeNotifier {
  late SaveCalendarColor _colorModel;
  final Box<SaveCalendarColor> _box;

  CalendarColorProvider(this._box) {
    _colorModel = _box.get('colors')!;
  }

  Color get todayColor => _colorModel.todayColor;
  Color get selectedDayColor => _colorModel.selectedDayColor;

  void setTodayColor(Color color) {
    _colorModel.todayColor = color;
    _colorModel.save();
    notifyListeners();
  }

  void setSelectedDayColor(Color color) {
    _colorModel.selectedDayColor = color;
    _colorModel.save();
    notifyListeners();
  }
}
