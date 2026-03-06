import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

enum TaskCategory { work, personal, health, shopping, other }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.other,
  });
}
