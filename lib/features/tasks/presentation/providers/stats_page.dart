import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/user_provider.dart';
import '../providers/task_provider.dart';
import '../../domain/entities/task_entity.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final now = DateTime.now();
        final currentWeekday = now.weekday;
        final monday = now.subtract(Duration(days: currentWeekday - 1));

        final weekDays = List.generate(
          7,
          (index) => monday.add(Duration(days: index)),
        );

        final weekTotal = provider.tasks.where((t) {
          final isInWeek =
              t.date.isAfter(monday.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(monday.add(const Duration(days: 7)));
          return isInWeek;
        }).toList();

        final totalWeekTasks = weekTotal.length;
        final completedWeekTasks = weekTotal.where((t) => t.isCompleted).length;

        final percentage = totalWeekTasks == 0
            ? 0.0
            : (completedWeekTasks / totalWeekTasks);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Салам, ${userProvider.userName ?? 'Алтынай'}!",
                            style: GoogleFonts.rubik(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            "Жумалык прогрессиңиз",
                            style: GoogleFonts.rubik(
                              fontSize: 16,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.insights_rounded,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildWeeklyProgressDashboard(
                  context,
                  provider,
                  weekDays,
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

  Widget _buildWeeklyProgressDashboard(
    BuildContext context,
    TaskProvider provider,
    List<DateTime> weekDays,
    double percentage,
    int completed,
    int total,
  ) {
    String feedbackMsg;
    IconData feedbackIcon;
    Color color;

    if (percentage > 0.8) {
      feedbackMsg = "Азаматсыз!";
      feedbackIcon = Icons.stars_rounded;
      color = AppColors.primaryGreen;
    } else if (percentage > 0.5) {
      feedbackMsg = "Жакшы бара жатасыз";
      feedbackIcon = Icons.thumb_up_rounded;
      color = AppColors.secondaryBlue;
    } else {
      feedbackMsg = "Дагы аракет кыл";
      feedbackIcon = Icons.bolt;
      color = Colors.orange;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ушул жумада $completed / $total аткарылды",
                      style: GoogleFonts.rubik(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(feedbackIcon, size: 30, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final dayTasks = provider.tasks
                    .where(
                      (t) =>
                          t.date.year == day.year &&
                          t.date.month == day.month &&
                          t.date.day == day.day,
                    )
                    .toList();

                final dayCompleted = dayTasks
                    .where((t) => t.isCompleted)
                    .length;
                final dayProgress = dayTasks.isEmpty
                    ? 0.0
                    : dayCompleted / dayTasks.length;
                final isToday =
                    DateTime.now().year == day.year &&
                    DateTime.now().month == day.month &&
                    DateTime.now().day == day.day;

                return Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isToday
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _getWeekdayInitial(day.weekday),
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isToday ? color : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dayTasks.isEmpty
                            ? Colors.white.withValues(alpha: 0.2)
                            : (dayProgress == 1.0
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Жалпы прогресс",
                  style: GoogleFonts.rubik(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${(percentage * 100).toInt()}%",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayInitial(int weekday) {
    const initials = ['Д', 'Ш', 'Ш', 'Б', 'Ж', 'И', 'Ж'];
    return initials[weekday - 1];
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
