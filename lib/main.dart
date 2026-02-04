import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'package:project_kun_tartip/features/tasks/data/models/task_model.dart';
import 'package:project_kun_tartip/features/tasks/presentation/providers/task_provider.dart';
import 'package:project_kun_tartip/screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasksBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'КүнТартип',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const SplashPage(),
    );
  }
}
