import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_kun_tartip/features/tasks/presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        // Assuming we want general stats or today? Image says "Weekly Summary" but let's stick to available data first.
        // Actually, let's calculate based on all tasks for now to match "Weekly" vaguely.

        final allTasks = provider.tasks;
        final totalCount = allTasks.length;
        final completedCount = allTasks.where((t) => t.isCompleted).length;
        final remainingCount = totalCount - completedCount;
        final percentage = totalCount == 0
            ? 0.0
            : (completedCount / totalCount);

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
                  'Жыйынтык',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Blue Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Жалпы жыйынтык',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Бардык мезгил үчүн',
                                style: GoogleFonts.rubik(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Аткарылган %',
                        '${(percentage * 100).toInt()}%',
                        Icons.check_circle_outline,
                        AppColors.primaryGreen,
                      ),
                      const SizedBox(height: 15),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percentage,
                          minHeight: 15,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildStatRowWithCount(
                        'Аткарылган:',
                        completedCount.toString(),
                        Icons.check_circle,
                        AppColors.primaryGreen,
                        true,
                      ),
                      Divider(color: Colors.grey.shade200, height: 30),
                      _buildStatRowWithCount(
                        'Калган:',
                        remainingCount.toString(),
                        Icons.cancel,
                        AppColors.red,
                        false,
                      ),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("", style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text(
                              "Жакшы бара жатасыз!",
                              style: GoogleFonts.rubik(
                                color: AppColors.secondaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRowWithCount(
    String label,
    String count,
    IconData icon,
    Color color,
    bool isGood,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.black87)),
            const SizedBox(width: 5),
            Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        if (!isGood)
          Text(
            'Калган: $count',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
