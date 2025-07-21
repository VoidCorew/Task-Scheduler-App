import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';
import 'package:tasks_scheduler/providers/theme_provider.dart';
import 'package:tasks_scheduler/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU', null);

  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);

  await Hive.initFlutter();

  Hive.registerAdapter(SaveTaskAdapter());
  await Hive.openBox<SaveTask>('tasks');
  await Hive.openBox<SaveTask>('trashed');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const TasksSchedulerApp(),
    ),
  );
}

class TasksSchedulerApp extends StatelessWidget {
  const TasksSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.currentTheme,
      home: HomeScreen(),
    );
  }
}
