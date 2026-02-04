import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String timeString; // TimeOfDay is not natively supported by Hive, store as string "HH:mm"

  @HiveField(5)
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.timeString,
    this.isCompleted = false,
  });

  // Convert from Entity to Model
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      timeString: '${task.time.hour}:${task.time.minute}',
      isCompleted: task.isCompleted,
    );
  }

  // Convert from Model to Entity
  Task toEntity() {
    final parts = timeString.split(':');
    return Task(
      id: id,
      title: title,
      description: description,
      date: date,
      time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
      isCompleted: isCompleted,
    );
  }
}
