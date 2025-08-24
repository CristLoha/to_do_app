import 'package:flutter/material.dart';
import '../constants/pomodoro_constants.dart';

class TimerCircle extends StatelessWidget {
  final double progress;
  final String timeText;

  const TimerCircle({
    super.key,
    required this.progress,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PomodoroConstants.timerSize,
      height: PomodoroConstants.timerSize,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: PomodoroConstants.timerStrokeWidth,
            backgroundColor: Theme.of(context).dividerColor.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          Center(
            child: Text(
              timeText,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}