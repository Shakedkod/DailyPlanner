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
                    return Center(
                        child: Text(
                            'No tasks for today',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),
                        ),
                    );
                
                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                        final task = tasks[index];
                        final nextTask = index < tasks.length - 1 ? tasks[index + 1] : null;

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
        return Center(
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
                    child: Icon(Icons.delete, color: Color(task.colorCode)),
                    onTap: () => _deleteTask(task),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                    child: Icon(Icons.check_circle, color: Color(task.colorCode)),
                    onTap: () {
                        task.isCompleted = !task.isCompleted;
                        // update the task without the put() method
                        setState(() {
                            final taskMap = tasksBox.toMap();
                            taskMap.forEach((key, value) {
                                    if (value.taskId == task.taskId && value.date == task.date)
                                    {
                                        tasksBox.put(key, task);
                                    }
                                });
                        });
                    },
                ),
                const SizedBox(width: 16),
            ],
        );
    }

    void _deleteTask(Task task) 
    {
        // check if the task is a repeating task
        if (task.repetition == "Never")
        {
            final taskMap = tasksBox.toMap();
            taskMap.forEach((key, value) {
                if (value.taskId == task.taskId && value.date == task.date)
                {
                    tasksBox.delete(key);
                }
            });
        }
        else
        {
            // show a dialog to confirm deletion
            showDialog( 
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text('Do you want to delete'),
                    actions: [
                        TextButton(
                            onPressed: () {
                                final taskMap = tasksBox.toMap();
                                taskMap.forEach((key, value) {
                                    if (value.taskId == task.taskId && value.date == task.date)
                                    {
                                        tasksBox.delete(key);
                                    }
                                });
                                Navigator.pop(context);
                            },
                            child: const Text('This Task Only'),
                        ),
                        TextButton(
                            onPressed: () {
                                Navigator.pop(context);
                                _deleteAllTasksWithSameTaskId(task);
                            },
                            child: const Text('All Tasks'),
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                        ),
                    ],
                ),
            );
        }
    }

    void _deleteAllTasksWithSameTaskId(Task task)
    {
        final taskMap = tasksBox.toMap();
        taskMap.forEach((key, value) {
            if (value.taskId == task.taskId)
            {
                tasksBox.delete(key);
            }
        });
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
        // calculate the height of the connector based on the difference in start times
        final height = DateServices.calculateDuration(
            DateServices.getEndTime(currentTask.startTime, currentTask.duration),
            nextTask.startTime,
        ).inMinutes.toDouble();

        return Container(
            height: (height / 20) + 20,
            width: 2,
            margin: const EdgeInsets.only(left: 43),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(currentTask.colorCode), Color(nextTask.colorCode)],
                )
            ),
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