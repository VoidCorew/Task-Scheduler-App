import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tasks_scheduler/hive_models/save_calendar_color.dart';
import 'package:tasks_scheduler/hive_models/save_task.dart';
import 'package:tasks_scheduler/providers/buttons_provider.dart';
import 'package:tasks_scheduler/providers/calendar_color_provider.dart';
import 'package:tasks_scheduler/providers/task_provider.dart';
import 'package:tasks_scheduler/providers/theme_provider.dart';
import 'package:tasks_scheduler/screens/home_screen.dart';
import 'package:tasks_scheduler/services/notification_service.dart';
import 'package:window_size/window_size.dart' as window;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const macSettings = DarwinInitializationSettings();
  const linuxSettings = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
  );

  const initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
    macOS: macSettings,
    linux: linuxSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Запрос разрешений
  final iosPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();
  await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

  final macPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin
      >();
  await macPlugin?.requestPermissions(alert: true, badge: true, sound: true);

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidPlugin?.requestNotificationsPermission();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isLinux) {
    const double width = 500;
    const double height = 800;

    window.setWindowTitle('Task Scheduler');
    window.setWindowMinSize(const Size(width, height));
    window.setWindowMaxSize(const Size(width, height));
  }

  await initializeDateFormatting('ru_RU', null);

  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);

  await Hive.initFlutter();

  Hive.registerAdapter(SaveTaskAdapter());
  Hive.registerAdapter(SaveCalendarColorAdapter());
  // await Hive.deleteBoxFromDisk('tasks');
  // await Hive.deleteBoxFromDisk('trashed');
  // await Hive.deleteBoxFromDisk('unsorted');
  await Hive.openBox<SaveTask>('tasks');
  await Hive.openBox<SaveTask>('trashed');
  await Hive.openBox<SaveTask>('unsorted');
  // await Hive.deleteBoxFromDisk('calendar_colors');
  final box = await Hive.openBox<SaveCalendarColor>('calendar_colors');

  if (box.isEmpty) {
    await box.put(
      'colors',
      SaveCalendarColor(
        todayColorValue: Colors.grey.toARGB32(),
        selectedDayColorValue: Colors.blue.toARGB32(),
      ),
    );
  }

  await initNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => CalendarColorProvider(box)),
        ChangeNotifierProvider(create: (_) => ButtonsProvider()),
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
