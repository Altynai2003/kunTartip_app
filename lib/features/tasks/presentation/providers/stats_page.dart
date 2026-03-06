import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/task_provider.dart';
import '../../domain/entities/task_entity.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final now = DateTime.now();
        final currentWeekday = now.weekday;
        final monday = now.subtract(Duration(days: currentWeekday - 1));

        final weekDays = List.generate(
          7,
          (index) => monday.add(Duration(days: index)),
        );

        int totalWeekTasks = 0;
        int completedWeekTasks = 0;

        for (var day in weekDays) {
          final tasksForDay = provider.tasks.where(
            (t) =>
                t.date.year == day.year &&
                t.date.month == day.month &&
                t.date.day == day.day,
          );
          totalWeekTasks += tasksForDay.length;
          completedWeekTasks += tasksForDay.where((t) => t.isCompleted).length;
        }

        final percentage = totalWeekTasks == 0
            ? 0.0
            : (completedWeekTasks / totalWeekTasks);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primaryGreen,
            elevation: 0,
            title: Text(
              'Жумалык жыйынтык',
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildProgressHeader(
                  percentage,
                  completedWeekTasks,
                  totalWeekTasks,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Күнүмдүк отчет',
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final day = weekDays[index];
                          return _buildDayCard(provider, day, now);
                        },
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

  Widget _buildProgressHeader(double percentage, int completed, int total) {
    String feedbackMsg = "Дагы аракет кыл";
    IconData feedbackIcon = Icons.bolt;
    Color color = Colors.orange;

    if (percentage > 0.8) {
      feedbackMsg = "Азаматсыз!";
      feedbackIcon = Icons.stars_rounded;
      color = AppColors.primaryGreen;
    } else if (percentage > 0.5) {
      feedbackMsg = "Жакшы бара жатасыз";
      feedbackIcon = Icons.thumb_up_rounded;
      color = AppColors.secondaryBlue;
    } else if (percentage > 0.1) {
      feedbackMsg = "Жакшы";
      feedbackIcon = Icons.trending_up_rounded;
      color = Colors.blue;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackMsg,
                      style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ушул жумада $completed / $total",
                      style: GoogleFonts.rubik(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Icon(feedbackIcon, size: 40, color: color),
              ],
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(percentage * 100).toInt()}% бүтүрүлдү",
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(TaskProvider provider, DateTime day, DateTime now) {
    final dayTasks = provider.tasks
        .where(
          (t) =>
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day,
        )
        .toList();

    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    final dayCompleted = dayTasks.where((t) => t.isCompleted).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isToday
            ? Border.all(color: AppColors.primaryGreen, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: const Border(),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primaryGreen : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.day.toString(),
                style: GoogleFonts.rubik(
                  color: isToday ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          _getWeekdayName(day.weekday),
          style: GoogleFonts.rubik(
            fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          "$dayCompleted / ${dayTasks.length} аткарылды",
          style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textGrey),
        ),
        trailing: Icon(
          dayTasks.isEmpty
              ? Icons.remove
              : (dayCompleted == dayTasks.length
                    ? Icons.check_circle
                    : Icons.pending_actions),
          color: dayTasks.isEmpty
              ? Colors.grey
              : (dayCompleted == dayTasks.length
                    ? AppColors.primaryGreen
                    : Colors.orange),
        ),
        children: [
          if (dayTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Бул күнү иштер жок",
                style: GoogleFonts.rubik(color: Colors.grey, fontSize: 13),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: dayTasks
                    .map(
                      (t) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              t.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 16,
                              color: t.isCompleted
                                  ? AppColors.primaryGreen
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                t.title,
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: t.isCompleted
                                      ? Colors.grey
                                      : AppColors.textDark,
                                  decoration: t.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            _buildPriorityIndicator(t.priority),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color = priority == TaskPriority.high
        ? AppColors.priorityHigh
        : priority == TaskPriority.medium
        ? AppColors.priorityMedium
        : AppColors.priorityLow;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _getWeekdayName(int weekday) {
    const days = [
      'Дүйшөмбү',
      'Шейшемби',
      'Шаршемби',
      'Бейшемби',
      'Жума',
      'Ишемби',
      'Жекшемби',
    ];
    return days[weekday - 1];
  }
}
