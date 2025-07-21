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

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task?.task ?? '');
    _noteController = TextEditingController(text: widget.task?.note ?? '');
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
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
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

              final task = SaveTask(
                task: text,
                time: DateTime.now(),
                note: note?.isEmpty == true ? null : note,
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
