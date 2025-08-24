import 'package:flutter/material.dart';
import '../constants/pomodoro_constants.dart';

class ControlButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const ControlButtons({
    super.key,
    required this.isRunning,
    required this.onPlayPause,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedButton(
          icon: Icons.refresh,
          onPressed: isRunning ? onReset : null,
          isRunning: isRunning,
        ),
        const SizedBox(width: PomodoroConstants.spacingSmall),
        FloatingActionButton.large(
          onPressed: onPlayPause,
          child: Icon(
            isRunning ? Icons.pause : Icons.play_arrow,
            size: PomodoroConstants.controlButtonSize,
          ),
        ),
        const SizedBox(width: PomodoroConstants.spacingSmall),
        _buildAnimatedButton(
          icon: Icons.skip_next,
          onPressed: isRunning ? onSkip : null,
          isRunning: isRunning,
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isRunning,
  }) {
    return AnimatedOpacity(
      duration: PomodoroConstants.animationDuration,
      opacity: isRunning ? 1.0 : 0.0,
      child: IconButton(
        icon: Icon(icon),
        iconSize: PomodoroConstants.iconButtonSize,
        onPressed: onPressed,
      ),
    );
  }
}