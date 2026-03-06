import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Priority-based color
    Color priorityColor = AppColors.priorityMedium;
    String priorityText = "Орто";

    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        priorityText = "Жогору";
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.priorityMedium;
        priorityText = "Орто";
        break;
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        priorityText = "Төмөн";
        break;
    }

    // Category info
    IconData categoryIcon = Icons.category;
    Color categoryColor = AppColors.catOther;
    String categoryText = "Башка";

    switch (task.category) {
      case TaskCategory.work:
        categoryIcon = Icons.work_outline;
        categoryColor = AppColors.catWork;
        categoryText = "Жумуш";
        break;
      case TaskCategory.personal:
        categoryIcon = Icons.person_outline;
        categoryColor = AppColors.catPersonal;
        categoryText = "Жеке";
        break;
      case TaskCategory.health:
        categoryIcon = Icons.favorite_border;
        categoryColor = AppColors.catHealth;
        categoryText = "Ден соолук";
        break;
      case TaskCategory.shopping:
        categoryIcon = Icons.shopping_cart_outlined;
        categoryColor = AppColors.catShopping;
        categoryText = "Сатып алуу";
        break;
      case TaskCategory.other:
        categoryIcon = Icons.more_horiz;
        categoryColor = AppColors.catOther;
        categoryText = "Башка";
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Left accent line (Priority indicator)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: priorityColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 12, 16),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.primaryGreen
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: task.isCompleted
                            ? Colors.white
                            : Colors.transparent,
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
                            fontWeight: FontWeight.w600,
                            color: task.isCompleted
                                ? Colors.grey
                                : AppColors.textDark,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildChip(
                              Icons.access_time,
                              "${task.time.hour.toString().padLeft(2, '0')}:${task.time.minute.toString().padLeft(2, '0')}",
                              Colors.blue.shade50,
                              Colors.blue.shade700,
                            ),
                            _buildChip(
                              categoryIcon,
                              categoryText,
                              categoryColor.withValues(alpha: 0.1),
                              categoryColor,
                            ),
                            if (!task.isCompleted)
                              _buildChip(
                                Icons.flag_outlined,
                                priorityText,
                                priorityColor.withValues(alpha: 0.1),
                                priorityColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions row
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.red.shade300,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.rubik(
              fontSize: 11,
              color: iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
