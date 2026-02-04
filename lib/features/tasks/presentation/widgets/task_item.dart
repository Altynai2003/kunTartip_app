import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../../../core/constants/app_colors.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Green accent line on the left
          Positioned(
            left: 0,
            top: 15,
            bottom: 15,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? AppColors.secondaryBlue
                    : AppColors.primaryGreen,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                // Checkbox
                InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppColors.primaryGreen
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: task.isCompleted
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChip(
                            Icons.access_time,
                            "${task.time.hour.toString().padLeft(2, '0')}:${task.time.minute.toString().padLeft(2, '0')}",
                            Colors.blue.shade50,
                            Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          _buildChip(
                            Icons.calendar_today,
                            DateFormat('d MMM').format(task.date),
                            Colors.purple.shade50,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    IconData icon,
    String label,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: iconColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
