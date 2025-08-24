import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_app/src/core/services/notification_service.dart';
import 'package:to_do_app/src/features/pomodoro/utils/pomodoro_utils.dart';

part 'pomodoro_state.dart';

class PomodoroCubit extends Cubit<PomodoroState> {
  Timer? _timer;

  final NotificationService _notificationService = NotificationService();

  PomodoroCubit() : super(PomodoroInitial()) {
    initialize();
  }

  void initialize() {
    const session = PomodoroSession.pomodoro;
    final duration = _getDurationForSession(session);

    emit(
      PomodoroRunState(
        selectedSession: session,
        totalSeconds: duration.inSeconds,
        remainingSeconds: duration.inSeconds,
        isRunning: false,
      ),
    );
  }

  void startTimer() {
    if (state is! PomodoroRunState) return;
    final currentState = state as PomodoroRunState;

    if (currentState.isRunning || currentState.remainingSeconds == 0) return;
    // Jadwalkan notifikasi dengan ID berdasarkan sesi
    final notificationId = currentState.selectedSession.index;

    /// Menjadwalkan Notifikasi saat timer dimulai
    _notificationService.scheduleNotification(
      id: notificationId,
      title: _getNotificationTitle(currentState.selectedSession),
      body: _getNotificationBody(currentState.selectedSession),
      duration: Duration(seconds: currentState.remainingSeconds),
    );
    emit(currentState.copyWith(isRunning: true));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is PomodoroRunState) {
        final runningState = state as PomodoroRunState;
        if (runningState.remainingSeconds > 0) {
          emit(
            runningState.copyWith(
              remainingSeconds: runningState.remainingSeconds - 1,
            ),
          );
        } else {
          stopTimer(isCompleted: true);
        }
      }
    });
  }

  void stopTimer({bool isCompleted = false}) {
    _timer?.cancel();

    /// Membatalkan Notifikasi jika timer dihentikan sebelum selesai
    if (!isCompleted) {
      _notificationService.cancelNotification(0);
    }
    if (state is PomodoroRunState) {
      final currentState = state as PomodoroRunState;
      emit(currentState.copyWith(isRunning: false));

      if (isCompleted) {
        skipToNextSession();
      }
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _notificationService.cancelNotification(0);
    if (state is PomodoroRunState) {
      final currentState = state as PomodoroRunState;
      final duration = _getDurationForSession(currentState.selectedSession);
      emit(
        currentState.copyWith(
          totalSeconds: duration.inSeconds,
          remainingSeconds: duration.inSeconds,
          isRunning: false,
        ),
      );
    }
  }

  void skipToNextSession() {
    if (state is! PomodoroRunState) return;
    final currentState = state as PomodoroRunState;
    final wasRunning = currentState.isRunning;

    _timer?.cancel();

    PomodoroSession nextSession;
    switch (currentState.selectedSession) {
      case PomodoroSession.pomodoro:
        nextSession = PomodoroSession.shortBreak;
        break;
      case PomodoroSession.shortBreak:
        nextSession = PomodoroSession.longBreak;
        break;
      case PomodoroSession.longBreak:
        nextSession = PomodoroSession.pomodoro;
        break;
    }
    final duration = _getDurationForSession(nextSession);
    emit(
      currentState.copyWith(
        selectedSession: nextSession,
        totalSeconds: duration.inSeconds,
        remainingSeconds: duration.inSeconds,
        isRunning: false,
      ),
    );
    // Jika timer sebelumnya sedang berjalan, mulai timer baru
    if (wasRunning) {
      startTimer();
    }
  }

  void changeSession(PomodoroSession session) {
    if (state is! PomodoroRunState) return;

    final currentState = state as PomodoroRunState;
    final wasRunning = currentState.isRunning;

    // Hentikan timer
    _timer?.cancel();

    // Batalkan notifikasi lama jika ada
    _notificationService.cancelNotification(0);

    final duration = _getDurationForSession(session);

    emit(
      PomodoroRunState(
        selectedSession: session,
        totalSeconds: duration.inSeconds,
        remainingSeconds: duration.inSeconds,
        isRunning: false,
      ),
    );

    // Jika sebelumnya running, langsung jalankan timer baru
    if (wasRunning) {
      startTimer();
    }
  }

  static Duration _getDurationForSession(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.pomodoro:
        return const Duration(minutes: 25);
      case PomodoroSession.shortBreak:
        return const Duration(minutes: 1);
      case PomodoroSession.longBreak:
        return const Duration(minutes: 15);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  String _getNotificationBody(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.pomodoro:
        return 'Waktunya istirahat sejenak.';
      case PomodoroSession.shortBreak:
        return 'Siap untuk mulai fokus lagi?';
      case PomodoroSession.longBreak:
        return 'Istirahat panjang selesai, ayo mulai sesi baru!';
    }
  }

  String _getNotificationTitle(PomodoroSession session) {
    switch (session) {
      case PomodoroSession.pomodoro:
        return 'Waktu Fokus Selesai!';
      case PomodoroSession.shortBreak:
        return 'Istirahat Pendek Selesai!';
      case PomodoroSession.longBreak:
        return 'Istirahat Panjang Selesai!';
    }
  }
}
