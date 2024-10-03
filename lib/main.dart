import 'package:daily_planner/box.dart';
import 'package:daily_planner/models/task.dart';
import 'package:daily_planner/pages/addTaskPage.dart';
import 'package:daily_planner/pages/homePage.dart';
import 'package:daily_planner/services/dateServices.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async
{
    await Hive.initFlutter();
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(TaskAdapter());
    await openBox();

    final now = DateTime.now();
    final wakingTasks = tasksBox.values.where((task) => DateServices.isSameDay(task.date, now) && task.title == 'Rise and Shine').toList();
    if (wakingTasks.isEmpty) Task.createRiseAndShineTask(now);

    final sleepingTasks = tasksBox.values.where((task) => DateServices.isSameDay(task.date, now) && task.title == "Wind Down").toList();
    if (sleepingTasks.isEmpty) Task.createWindDownTask(now);

    runApp(const DailyPlannerApp());
}

class DailyPlannerApp extends StatefulWidget 
{
    const DailyPlannerApp({super.key});

    @override
    State<DailyPlannerApp> createState() => _DailyPlannerAppState();
}

class _DailyPlannerAppState extends State<DailyPlannerApp> 
{
    @override
    Widget build(BuildContext context) 
    {
        return MaterialApp(
            title: 'Daily Planner',
            localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
                Locale('en', 'US'),
                Locale('he', 'IL'),
            ],
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), 
                child: child ?? const SizedBox()
            ),
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
            routes: {
                '/addTask': (context) => const AddTaskPage(),
            },
        );
    }
}