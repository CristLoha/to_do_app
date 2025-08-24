import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/src/features/pomodoro/presentation/bloc/pomodoro/pomodoro_cubit.dart';
import 'package:to_do_app/src/features/pomodoro/utils/pomodoro_utils.dart';
import '../constants/pomodoro_constants.dart';
import '../widgets/control_buttons.dart';
import '../widgets/session_button.dart';
import '../widgets/timer_circle.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PomodoroCubit(),
      child: const _PomodoroView(),
    );
  }
}

class _PomodoroView extends StatelessWidget {
  const _PomodoroView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fokus Pomodoro')),
      body: BlocBuilder<PomodoroCubit, PomodoroState>(
        builder: (context, state) {
          if (state is PomodoroInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PomodoroError) {
            return Center(child: Text(state.message));
          }

          final runState = state as PomodoroRunState;
          return _buildTimerView(context, runState);
        },
      ),
    );
  }

  Widget _buildTimerView(BuildContext context, PomodoroRunState state) {
    return Column(
      children: [
        const SizedBox(height: PomodoroConstants.spacingMedium),
        _buildSessionButtons(context, state),
        const Spacer(),
        TimerCircle(
          progress: _calculateProgress(state),
          timeText: _formatTime(state.remainingSeconds),
        ),
        const SizedBox(height: PomodoroConstants.spacingLarge),
        ControlButtons(
          isRunning: state.isRunning,
          onPlayPause: () => _handlePlayPause(context, state),
          onReset: () => context.read<PomodoroCubit>().resetTimer(),
          onSkip: () => context.read<PomodoroCubit>().skipToNextSession(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSessionButtons(BuildContext context, PomodoroRunState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildSessionButton(
            context,
            PomodoroSession.pomodoro,
            Icons.work_outline,
            'Pomodoro',
            state.selectedSession,
          ),
          _buildSessionButton(
            context,
            PomodoroSession.shortBreak,
            Icons.free_breakfast_outlined,
            'Pendek',
            state.selectedSession,
          ),
          _buildSessionButton(
            context,
            PomodoroSession.longBreak,
            Icons.bedtime_outlined,
            'Panjang',
            state.selectedSession,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionButton(
    BuildContext context,
    PomodoroSession session,
    IconData icon,
    String label,
    PomodoroSession selectedSession,
  ) {
    return SessionButton(
      isSelected: selectedSession == session,
      icon: icon,
      label: label,
      onTap: () => context.read<PomodoroCubit>().changeSession(session),
    );
  }

  double _calculateProgress(PomodoroRunState state) {
    return state.totalSeconds > 0
        ? state.remainingSeconds / state.totalSeconds
        : 1.0;
  }

  void _handlePlayPause(BuildContext context, PomodoroRunState state) {
    if (state.isRunning) {
      context.read<PomodoroCubit>().stopTimer();
    } else {
      context.read<PomodoroCubit>().startTimer();
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
