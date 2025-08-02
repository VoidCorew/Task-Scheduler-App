import 'package:flutter/material.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
// import 'package:tasks_scheduler/models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  // final Task? task;
  final SaveTask? task;
  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late final TextEditingController _taskController;
  late final TextEditingController? _noteController;
  late final TextEditingController? _dateController;
  late final TextEditingController? _timeController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _showDatePicker() async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        // locale: const Locale('en'),
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
          _dateController?.text =
              "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
          debugPrint(_selectedDate.toString());
        });
      }
    } catch (e) {
      debugPrint("Ошибка во время показа datePicker: $e");
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    try {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        orientation: Orientation.portrait,
        builder: (context, child) {
          return Theme(
            data: Theme.of(
              context,
            ).copyWith(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ),
            ),
          );
        },
      );

      if (pickedTime != null) {
        // final formattedTime = pickedTime.format(context);
        final formattedTime = MaterialLocalizations.of(
          context,
        ).formatTimeOfDay(pickedTime, alwaysUse24HourFormat: true);
        setState(() {
          _selectedTime = pickedTime;
          _timeController?.text = formattedTime;
        });
      }
    } catch (e) {
      debugPrint('Ошибка во время показа datePicker: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task?.task ?? '');
    _noteController = TextEditingController(text: widget.task?.note ?? '');
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _taskController.dispose();
    _noteController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Создать задачу' : 'Редактировать задачу',
          style: TextStyle(fontFamily: 'Jost'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: const Text(
                'Введите задачу',
                style: TextStyle(fontFamily: 'Monsterrat'),
              ),
              label: const Text(
                'Задача',
                style: TextStyle(fontFamily: 'Monsterrat'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hint: const Text(
                'Введите пометку к задаче если нужно',
                style: TextStyle(fontFamily: 'Monsterrat'),
              ),
              label: const Text(
                'Пометка',
                style: TextStyle(fontFamily: 'Monsterrat'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: _dateController,
                  decoration: InputDecoration(
                    label: const Text('Дата'),
                    hint: const Text('Выберите дату'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _showDatePicker,
                icon: Icon(Icons.calendar_month),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: _timeController,
                  decoration: InputDecoration(
                    label: const Text('Время'),
                    hint: const Text('Выберите время'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _showTimePicker(context),
                icon: Icon(Icons.watch_later_outlined),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              final now = DateTime.now();
              final text = _taskController.text;
              final note = _noteController?.text;

              if (text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Введите свою задачу!',
                      style: TextStyle(fontFamily: 'Monsterrat'),
                    ),
                  ),
                );
                return;
              }

              final combinedDateTime = DateTime(
                _selectedDate?.year ?? now.year,
                _selectedDate?.month ?? now.month,
                _selectedDate?.day ?? now.day,
                _selectedTime?.hour ?? now.hour,
                _selectedTime?.minute ?? now.minute,
              );

              final task = SaveTask(
                task: text,
                dateTime: combinedDateTime,
                note: note?.isEmpty == true ? null : note,
                isDone: false,
                hasDate: _selectedDate != null,
                hasTime: _selectedTime != null,
              );

              Navigator.pop(context, task);
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(fontFamily: 'Monsterrat'),
            ),
          ),
        ],
      ),
    );
  }
}
