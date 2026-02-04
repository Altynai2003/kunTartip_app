import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';

class TaskProvider extends ChangeNotifier {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Эртең мененки иштер (06:00 - 12:00)
  List<Task> get morningTasks => _tasks.where((task) {
    if (task.isCompleted) return false;
    final hour = task.time.hour;
    return hour >= 6 && hour < 12;
  }).toList();

  // Бүгүнкү аткарылган иштер
  int get completedTodayCount {
    final now = DateTime.now();
    return _tasks
        .where(
          (task) =>
              task.isCompleted &&
              task.date.year == now.year &&
              task.date.month == now.month &&
              task.date.day == now.day,
        )
        .length;
  }

  // Бүгүнкү пландалган иштер (Бардыгы)
  int get totalTodayCount {
    final now = DateTime.now();
    return _tasks
        .where(
          (task) =>
              task.date.year == now.year &&
              task.date.month == now.month &&
              task.date.day == now.day,
        )
        .length;
  }

  Future<void> loadTasks() async {
    final taskModels = _dataSource.getTasks();
    _tasks = taskModels.map((e) => e.toEntity()).toList();
    // Sort by time
    _tasks.sort((a, b) {
      if (a.date.compareTo(b.date) != 0) {
        return a.date.compareTo(b.date);
      }
      final aTime = a.time.hour * 60 + a.time.minute;
      final bTime = b.time.hour * 60 + b.time.minute;
      return aTime.compareTo(bTime);
    });
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      date: date,
      time: time,
    );

    await _dataSource.addTask(TaskModel.fromEntity(newTask));
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      time: task.time,
      isCompleted: !task.isCompleted,
    );

    await _dataSource.updateTask(TaskModel.fromEntity(updatedTask));
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _dataSource.deleteTask(id);
    await loadTasks();
  }

  // Initialize DB
  Future<void> init() async {
    await _dataSource.init();
    await loadTasks();
  }
}
