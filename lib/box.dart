import 'package:daily_planner/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box<Task> tasksBox = Hive.box<Task>('tasks');
bool _boxOpened = false;

deleteTask(Task task) 
{
    tasksBox.delete(task.key);
}

Task? getTaskByKey(int key) 
{
    return tasksBox.get(key);
}

Future<void> openBox() async 
{
    if (!_boxOpened) 
    {
        await Hive.openBox<Task>('tasks');
        _boxOpened = true;
    }
}