import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:project_kun_tartip/features/tasks/presentation/providers/task_provider.dart';
import 'package:project_kun_tartip/features/tasks/data/models/task_model.dart';

void main() {
  test('toggleTaskStatus only works for today', () async {
    await Hive.initFlutter('test_hive');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    final provider = TaskProvider();
    await provider.init();

    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    // Add task for tomorrow
    await provider.addTask(
      title: 'Tomorrow Task',
      description: 'Test',
      date: tomorrow,
      time: const TimeOfDay(hour: 10, minute: 0),
    );

    var task = provider.tasks.firstWhere((t) => t.title == 'Tomorrow Task');
    expect(task.isCompleted, false);

    // Try to toggle it
    await provider.toggleTaskStatus(task);

    task = provider.tasks.firstWhere((t) => t.title == 'Tomorrow Task');
    expect(
      task.isCompleted,
      false,
      reason: 'Task from tomorrow should not be toggleable',
    );
  });
}
