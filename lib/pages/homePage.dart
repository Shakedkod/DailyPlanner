import 'package:daily_planner/components/CustomDatePickerTimeline.dart';
import 'package:daily_planner/components/TaskList.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget 
{
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
    DateTime _selectedDate = DateTime.now();

    void _onDateSelected(DateTime date) 
    {
        setState(() {
            _selectedDate = date;
        });
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Weekly Schedule'),
                centerTitle: true,
                systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
                titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                iconTheme: Theme.of(context).appBarTheme.iconTheme,
                actions: [
                    IconButton(
                        onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                        },
                        icon: const Icon(Icons.settings),
                    ),
                ],
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
                children: [
                    CustomDatePickerTimeline(
                        selectedDate: _selectedDate,
                        onDateSelected: _onDateSelected,
                    ),
                    Expanded(
                        child: TaskList(selectedDate: _selectedDate),
                    ),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/addTask');
                },
                backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                focusColor: Theme.of(context).floatingActionButtonTheme.focusColor,
                hoverColor: Theme.of(context).floatingActionButtonTheme.hoverColor,
                splashColor: Theme.of(context).floatingActionButtonTheme.splashColor,
                child: const Icon(
                    Icons.add,
                ),
            ),
        );
    }
}