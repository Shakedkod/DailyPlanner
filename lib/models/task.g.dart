// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      taskId: fields[1] as String,
      title: fields[2] as String,
      date: fields[3] as DateTime,
      startTime: fields[4] as TimeOfDay,
      duration: fields[5] as Duration,
      colorCode: fields[6] as int,
      iconCodePoint: fields[7] as int,
      repetition: fields[8] as String,
      details: fields[9] as String,
      isAutomatic: fields[10] as bool,
    )
      ..key = fields[0] as int
      ..isCompleted = fields[11] as bool;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.colorCode)
      ..writeByte(7)
      ..write(obj.iconCodePoint)
      ..writeByte(8)
      ..write(obj.repetition)
      ..writeByte(9)
      ..write(obj.details)
      ..writeByte(10)
      ..write(obj.isAutomatic)
      ..writeByte(11)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
