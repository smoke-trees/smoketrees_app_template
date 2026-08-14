import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';
import 'package:smoketrees_app_template/utils/console_logger.dart';
import 'package:stac/stac.dart';

import '../../../core/services/global_service.dart';
import '../to_do.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({
    super.key,
    this.serialNumberMarkWidth = 44,
    this.serialNumberMarkHeight = 44,
    this.completeColor,
    this.deleteColor,
    required this.todo,
    this.onToggleComplete,
    this.onDelete,
  });

  final double? serialNumberMarkWidth;
  final double? serialNumberMarkHeight;
  final Color? completeColor;
  final Color? deleteColor;
  final ToDo todo;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isCompleted = todo.completed == true;
    final hasDescription = (todo.description ?? '').trim().isNotEmpty;

    return Dismissible(
      key: ValueKey('dismiss-${todo.id ?? todo.hashCode}'),
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: completeColor ?? AppColors.primaryColor,
        icon: isCompleted ? Icons.replay_rounded : Icons.check_circle_rounded,
        label: isCompleted ? 'Undo' : 'Complete',
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: deleteColor ?? Colors.redAccent,
        icon: Icons.delete_rounded,
        label: 'Delete',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggleComplete?.call();
          return false;
        }
        bool result = false;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete this to-do?'),
            content: Text(
              todo.title?.isNotEmpty == true
                  ? '"${todo.title}" will be removed.'
                  : 'This item will be removed.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  result = false;
                  await Stac.onCallFromJson(
                    StacNavigator.pop().toJson(),
                    context,
                  );
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  result = true;
                  await Stac.onCallFromJson(
                    StacNavigator.pop().toJson(),
                    context,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        ConsoleLogger.debug('result: $result');
        return result;
      },
      onDismissed: (e) {
        ConsoleLogger.debug('onDismissed ${e.name}');
        onDelete?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.grey2.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompleted
                ? AppColors.grey2.withOpacity(0.6)
                : AppColors.grey2.withOpacity(0.8),
          ),
          boxShadow: isCompleted
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onToggleComplete,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: serialNumberMarkWidth,
                        height: serialNumberMarkHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isCompleted
                              ? null
                              : LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor.withOpacity(0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: isCompleted
                              ? AppColors.grey1.withOpacity(0.4)
                              : null,
                          boxShadow: isCompleted
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: Text(
                            todo.serialNumber?.toString() ?? '',
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GlobalService.to
                                  .textTheme(context)
                                  .titleMedium
                                  ?.copyWith(
                                    color: isCompleted
                                        ? AppColors.grey1
                                        : AppColors.textDark,
                                    fontWeight: FontWeight.w700,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: AppColors.grey1,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            _buildStatusPill(isCompleted),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _CompleteButton(
                        isCompleted: isCompleted,
                        onTap: onToggleComplete,
                      ),
                    ],
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.grey2.withOpacity(0.2)
                            : AppColors.grey2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        todo.description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GlobalService.to
                            .textTheme(context)
                            .bodyMedium
                            ?.copyWith(
                              color: isCompleted
                                  ? AppColors.grey1.withOpacity(0.7)
                                  : AppColors.grey1,
                              height: 1.4,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppColors.grey1.withOpacity(0.5),
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.primaryColor.withOpacity(0.12)
            : Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isCompleted ? 'Completed' : 'In progress',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isCompleted ? AppColors.primaryColor : Colors.orange.shade800,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isLeft
            ? [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
            : [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white),
              ],
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.isCompleted, this.onTap});

  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            key: ValueKey(isCompleted),
            color: isCompleted ? AppColors.primaryColor : AppColors.grey1,
            size: 30,
          ),
        ),
      ),
    );
  }
}
