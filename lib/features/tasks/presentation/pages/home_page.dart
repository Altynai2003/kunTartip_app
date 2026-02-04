import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final tasks = provider.tasks;
        final completedCount = provider.completedTodayCount;
        final todayTotal = provider.totalTodayCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            title: Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.yellow, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Бүгүнкү иштер',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: AppColors.primaryGreen),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddTaskDialog(),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Green background extension
              Container(
                color: AppColors.primaryGreen,
                height: 20,
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  children: [
                    // Summary Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          SummaryCard(
                            title: 'Бүгүн',
                            count: todayTotal.toString(),
                            icon: Icons.calendar_today,
                            color: AppColors.primaryGreen,
                          ),
                          SummaryCard(
                            title: 'Аткарылды',
                            count: completedCount.toString(),
                            icon: Icons.check_circle_outline,
                            color: AppColors.secondaryBlue,
                          ),
                          SummaryCard(
                            title: 'Жалпы',
                            count: tasks.length.toString(),
                            icon: Icons.bar_chart,
                            color: AppColors.accentOrange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Task List
                    if (tasks.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Бүгүнкүгө пландар жок",
                                style: GoogleFonts.rubik(
                                  color: AppColors.textGrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...tasks.map(
                        (task) => TaskItem(
                          task: task,
                          onToggle: () => provider.toggleTaskStatus(task),
                          onDelete: () => provider.deleteTask(task.id),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
