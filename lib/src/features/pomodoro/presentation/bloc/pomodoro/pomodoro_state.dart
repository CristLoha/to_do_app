part of 'pomodoro_cubit.dart';

sealed class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object> get props => [];
}

final class PomodoroInitial extends PomodoroState {}

final class PomodoroError extends PomodoroState {
  final String message;

  const PomodoroError(this.message);

  @override
  List<Object> get props => [message];
}

final class PomodoroRunState extends PomodoroState {
  final PomodoroSession selectedSession;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;

  const PomodoroRunState({
    required this.selectedSession,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
  });

  PomodoroRunState copyWith({
    PomodoroSession? selectedSession,
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
  }) {
    return PomodoroRunState(
      selectedSession: selectedSession ?? this.selectedSession,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object> get props => [
    selectedSession,
    totalSeconds,
    remainingSeconds,
    isRunning,
  ];
}
