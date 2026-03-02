import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/task_provider.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        // Calculate weekly stats
        // We will show the last 7 days including today, or maybe just the current week (Mon-Sun).
        // Let's go with "Last 7 days" for simplicity and better data population,
        // OR "Current Week from Monday".
        // User image shows "Wednesday, Jan 14" -> "Sunday, Jan 18".
        // Let's show current week (Mon -> Sun).

        final now = DateTime.now();
        // Find the most recent Monday
        final currentWeekday = now.weekday;
        final monday = now.subtract(Duration(days: currentWeekday - 1));

        // Generate list of 7 days starting from Monday
        final weekDays = List.generate(
          7,
          (index) => monday.add(Duration(days: index)),
        );

        // Calculate overall stats for this week
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

        // Feedback Message logic
        String feedbackMsg = "";
        Color feedbackColor = AppColors.secondaryBlue;
        if (percentage <= 0.1) {
          feedbackMsg = "Дагы аракет кыл";
          feedbackColor = Colors.orange;
        } else if (percentage <= 0.5) {
          feedbackMsg = "Жакшы";
          feedbackColor = Colors.blue;
        } else if (percentage <= 0.8) {
          feedbackMsg = "Жакшы бара жатасыз";
          feedbackColor = AppColors.secondaryBlue;
        } else {
          feedbackMsg = "Азаматсыз";
          feedbackColor = AppColors.primaryGreen;
        }

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
                  'Жума жыйынтыгы',
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
                // Motivational Feedback Card (Only if there is data or always?)
                // Let's always show it to encourage empty state too.
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Аткарылган %',
                            style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey,
                            ),
                          ),
                          Text(
                            '${(percentage * 100).toInt()}%',
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percentage,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            feedbackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: feedbackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (percentage > 0.8)
                              const Icon(
                                Icons.star,
                                color: AppColors.primaryGreen,
                                size: 20,
                              )
                            else if (percentage > 0.5)
                              Icon(
                                Icons.thumb_up,
                                color: feedbackColor,
                                size: 20,
                              )
                            else
                              Icon(Icons.bolt, color: feedbackColor, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              feedbackMsg,
                              style: GoogleFonts.rubik(
                                color: feedbackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Weekly List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final day = weekDays[index];
                    final dayTasks = provider.tasks
                        .where(
                          (t) =>
                              t.date.year == day.year &&
                              t.date.month == day.month &&
                              t.date.day == day.day,
                        )
                        .toList();

                    final dayTotal = dayTasks.length;
                    final dayCompleted = dayTasks
                        .where((t) => t.isCompleted)
                        .length;

                    // Formatting date: e.g. "Шаршемби, Янв 14"
                    // We need a helper or intl.
                    // Assuming 'ky' locale might not be initialized, let's map weekdays manually if needed,
                    // or just use default local names if user phone is in Russian/Kyrgyz.
                    // Let's use DateFormat with 'ky' if possible, or fallback.
                    // Since I can't guarantee 'ky' locale data is loaded, I'll use a custom formatter or just English/Russian for now and map it?
                    // The user prompt used "Шаршемби" (Wednesday).

                    final weekdayName = _getWeekdayName(day.weekday);
                    final monthName = _getMonthName(day.month);

                    final isToday =
                        day.year == now.year &&
                        day.month == now.month &&
                        day.day == now.day;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isToday
                            ? Border.all(
                                color: AppColors.primaryGreen,
                                width: 2,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$weekdayName, $monthName ${day.day}',
                                style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      dayCompleted == dayTotal && dayTotal > 0
                                      ? AppColors.primaryGreen
                                      : (dayCompleted > 0
                                            ? Colors.orange
                                            : Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$dayCompleted / $dayTotal',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Optional: Show task titles specifically if requested?
                          // "ошол эле беттеги жакшы бара жатасыз дегенди иф елсе аркылуу жасасан жакшы болот эле мисалга 10 % иш бутсо демек дагы аракет кыл 50% кылса жакшы 80% жакшы бара атасыз 100 азаматсын деген сыяктуу жана башкы бетте бугунку гана иштер корунгудой кылсан жакшы болмок ал иштер касы кунго болсо ошол кунго чыккыдай болуп"
                          // The last part "ал иштер касы кунго болсо ошол кунго чыккыдай болуп" implies tasks should appear under their respective days.
                          // So yes, I should show the tasks inside this day card.
                          if (dayTasks.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey.shade100),
                            ...dayTasks.map(
                              (task) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      task.isCompleted
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      size: 16,
                                      color: task.isCompleted
                                          ? AppColors.primaryGreen
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          color: task.isCompleted
                                              ? Colors.grey
                                              : Colors.black87,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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

  String _getMonthName(int month) {
    const months = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек',
    ];
    return months[month - 1];
  }
}
