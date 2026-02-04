import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  static const String boxName = 'tasksBox';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<TaskModel>(boxName);
    }
  }

  Box<TaskModel> get _box => Hive.box<TaskModel>(boxName);

  List<TaskModel> getTasks() {
    return _box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    // Use id as key to easily retrieve/update if needed, or just add
    await _box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
