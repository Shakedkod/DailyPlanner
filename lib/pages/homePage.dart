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
            ),
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
                child: const Icon(Icons.add),
            ),
        );
    }
}