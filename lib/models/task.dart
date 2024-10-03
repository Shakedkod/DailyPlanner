import 'package:daily_planner/box.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task 
{
    @HiveField(0) // a key to identify the task
    int key;

    @HiveField(1) // the id of the task will be used for repeating tasks - to change all of the future tasks at once
    String taskId;

    @HiveField(2)
    String title;

    @HiveField(3)
    DateTime date;

    @HiveField(4)
    TimeOfDay startTime;

    @HiveField(5)
    Duration duration;

    @HiveField(6)
    int colorCode;

    @HiveField(7)
    int iconCodePoint;

    @HiveField(8)
    String repetition; // e.g., "daily", "weekly", "monthly"

    @HiveField(9)
    String details;

    @HiveField(10)
    bool isAutomatic;

    @HiveField(11)
    bool isCompleted = false;

    Task({
        required this.taskId,
        required this.title,
        required this.date,
        required this.startTime,
        required this.duration,
        required this.colorCode,
        required this.iconCodePoint,
        required this.repetition,
        required this.details,
        this.isAutomatic = false,
    }) : key = DateTime.now().millisecondsSinceEpoch + DateTime.now().year + DateTime.now().month + DateTime.now().day;

    static void createRiseAndShineTask(DateTime date) 
    {
        for (int i = 0; i < 365; i++)
        {
            final date = DateTime.now().add(Duration(days: i));
            final task = Task(
                taskId: "wake-up-main-task",
                title: "Rise and Shine",
                date: date,
                startTime: const TimeOfDay(hour: 7, minute: 0),
                duration: const Duration(minutes: 1),
                colorCode: Colors.yellow.hashCode,
                iconCodePoint: Icons.wb_sunny.codePoint,
                repetition: "daily",
                details: "Wake up and start the day with a smile!",
                isAutomatic: true,
            );

            tasksBox.add(task);
        }
    }

    static void createWindDownTask(DateTime date) 
    {
        for (int i = 0; i < 365; i++)
        {
            final date = DateTime.now().add(Duration(days: i));
            final task = Task(
                taskId: "sleep-main-task",
                title: "Wind Down",
                date: date,
                startTime: const TimeOfDay(hour: 21, minute: 0),
                duration: const Duration(minutes: 1),
                colorCode: Colors.blue.hashCode,
                iconCodePoint: Icons.nightlight_round.codePoint,
                repetition: "daily",
                details: "Relax and prepare for a good night's sleep.",
                isAutomatic: true,
            );

            tasksBox.add(task);
        }
    }
}

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> 
{
    @override
    final int typeId = 1;

    @override
    TimeOfDay read(BinaryReader reader) 
    {
        final hour = reader.readByte();
        final minute = reader.readByte();
        return TimeOfDay(hour: hour, minute: minute);
    }

    @override
    void write(BinaryWriter writer, TimeOfDay obj)
    {
        writer.writeByte(obj.hour);
        writer.writeByte(obj.minute);
    }
}

class DurationAdapter extends TypeAdapter<Duration> 
{
    @override
    final int typeId = 2; // Choose a unique type ID

    @override
    Duration read(BinaryReader reader) 
    {
        final inMicroseconds = reader.readInt();
        return Duration(microseconds: inMicroseconds);
    }

    @override
    void write(BinaryWriter writer, Duration obj) 
    {
        writer.writeInt(obj.inMicroseconds);
    }
}