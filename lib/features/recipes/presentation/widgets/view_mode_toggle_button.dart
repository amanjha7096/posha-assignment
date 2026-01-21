import 'package:flutter/material.dart';
import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/core/enums/view_mode.dart';

class ViewModeToggleButton extends StatelessWidget {
  final ViewMode viewMode;
  final VoidCallback onPressed;

  const ViewModeToggleButton({
    super.key,
    required this.viewMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
          key: ValueKey<ViewMode>(viewMode),
        ),
      ),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
