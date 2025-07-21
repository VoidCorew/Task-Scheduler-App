import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';
import 'package:tasks_scheduler/widgets/returnable_list.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    // final trashed = taskProvider.trashed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина', style: TextStyle(fontFamily: 'Jost')),
      ),
      body: ListView.builder(
        itemCount: taskProvider.trashed.length,
        itemBuilder: (context, index) {
          return returnableTile(context, taskProvider, index);
        },
      ),
    );
  }
}
