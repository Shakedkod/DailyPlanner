import 'package:daily_planner/box.dart';
import 'package:daily_planner/models/task.dart';
import 'package:daily_planner/pages/editTaskPage.dart';
import 'package:daily_planner/services/dateServices.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskList extends StatefulWidget 
{
    final DateTime selectedDate;

    const TaskList({super.key, required this.selectedDate});

    @override
    State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> 
{
    @override
    void initState() 
    {
        super.initState();
        tasksBox = Hive.box<Task>('tasks');
    }

    @override
    Widget build(BuildContext context) 
    {
        return ValueListenableBuilder<Box<Task>>(
            valueListenable: tasksBox.listenable(),
            builder: (context, box, _)                                      
            {
                final tasks = box.values.where((task) => DateServices.isSameDay(task.date, widget.selectedDate)).toList();
                tasks.sort((a, b) => DateServices.compareTo(a.startTime, b.startTime));

                if (tasks.isEmpty)
                    return const Center(child: Text('No tasks for today'));
                
                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                        final task = tasks[index];
                        final nextTask = index < tasks.length - 1 ? tasks[index + 1] : null;

                        return Column(
                            children: [
                                _buildTimeIndicator(task.startTime),
                                _buildTaskItem(task),
                                if (nextTask != null) _buildConnector(task, nextTask),
                            ],
                        );
                    },
                );
            },
        );
    }

    Widget _buildTimeIndicator(TimeOfDay time) {
        return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
                time.format(context),
                style: TextStyle(color: Colors.grey[600]),
            ),
        );
    }
    
    Widget _buildTaskItem(Task task) 
    {
        try
        {
            final isCompleted = task.isCompleted;
        }
        catch (e)
        {
            task.isCompleted = false;
        }

        return Row(
            children: [
                const SizedBox(width: 24),
                _buildColoredCircle(task, task.colorCode, task.iconCodePoint),
                const SizedBox(width: 16),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    "${task.startTime.format(context)} - ${findTaskEndTime(task).format(context)} (${task.duration.inMinutes}m)"
                                ),
                                Text(
                                    task.title, 
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                        color: task.isCompleted ? Colors.grey : Colors.black,
                                    )
                                ),
                            ],
                        ),
                    ),
                ),
                GestureDetector(
                    child: Icon(Icons.check_circle, color: Color(task.colorCode)),
                    onTap: () {
                        task.isCompleted = !task.isCompleted;
                        task.save();
                    },
                ),
                const SizedBox(width: 16),
            ],
        );
    }
    
    Widget _buildColoredCircle(Task task, int colorCode, int iconCodePoint) 
    {
        return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskPage(task: task))),
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(colorCode),
                    shape: BoxShape.circle,
                ),
                child: Center(
                    child: Icon(
                        IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                    ),
                ),
            ),
        );
    }
    
    Widget _buildConnector(Task currentTask, Task nextTask) 
    {
        return Container(
            height: 30,
            width: 2,
            margin: const EdgeInsets.only(left: 43),
            color: Color(currentTask.colorCode),
        );
    }

    TimeOfDay findTaskEndTime(Task task) 
    {
        return task.startTime.replacing(
            hour: task.startTime.hour + task.duration.inHours,
            minute: task.startTime.minute + task.duration.inMinutes % 60,
        );
    }
}