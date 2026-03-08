import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/user_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final now = DateTime.now();

        final todayTasks = provider.tasks.where((task) {
          return task.date.year == now.year &&
              task.date.month == now.month &&
              task.date.day == now.day;
        }).toList();

        final displayTasks = _selectedTabIndex == 0
            ? todayTasks
            : provider.tasks;

        final completedToday = provider.completedTodayCount;
        final totalToday = provider.totalTodayCount;
        final progress = totalToday > 0 ? completedToday / totalToday : 0.0;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            title: Row(
              children: [
                const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.yellow,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _getGreeting(userProvider.userName),
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [_buildAddButton(context)],
          ),
          body: Column(
            children: [
              _buildModernHeader(completedToday, totalToday, progress),
              _buildTabSection(),
              Expanded(
                child: displayTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        itemCount: displayTasks.length,
                        itemBuilder: (context, index) {
                          final task = displayTasks[index];
                          return TaskItem(
                            task: task,
                            onToggle: () => provider.toggleTaskStatus(task),
                            onDelete: () => provider.deleteTask(task.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting(String? name) {
    final hour = DateTime.now().hour;
    final displayName = name ?? 'Алтынай';
    if (hour < 12) return "Кутман таң, $displayName!";
    if (hour < 18) return "Кутман күн, $displayName!";
    return "Кутман кеч, $displayName!";
  }

  Widget _buildModernHeader(int completed, int total, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Бүгүнкү прогресс",
                    style: GoogleFonts.rubik(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$completed / $total аткарылды",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [_buildTab(0, "Бүгүн"), _buildTab(1, "Баары")]),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.rubik(
                color: isSelected ? AppColors.primaryGreen : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTabIndex == 0 ? "Бүгүнкүгө пландар жок" : "Пландар жок",
            style: GoogleFonts.rubik(
              color: AppColors.textGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Жаңы иш кошуу үчүн + баскычын басыңыз",
            style: GoogleFonts.rubik(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTaskDialog(),
        ),
      ),
    );
  }
}
