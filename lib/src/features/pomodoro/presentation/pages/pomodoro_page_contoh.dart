// import 'dart:async'; // Import untuk menggunakan kelas Timer.

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:to_do_app/src/features/pomodoro/utils/pomodoro_utils.dart'; // Import file utils kita
// import 'package:to_do_app/src/features/todo/presentation/widgets/adaptive_app_bar.dart';

// class PomodoroPage extends StatefulWidget {
//   const PomodoroPage({super.key});

//   @override
//   State<PomodoroPage> createState() => _PomodoroPageState();
// }

// class _PomodoroPageState extends State<PomodoroPage> {
//   // --- STATE WIDGET ---
//   // Variabel-variabel ini menyimpan kondisi saat ini dari halaman Pomodoro.

//   Timer? _timer; // Objek timer yang akan berjalan setiap detik.
//   PomodoroSession _selectedSession = PomodoroSession.pomodoro;
//   late int _totalSeconds; // Total durasi sesi dalam detik.
//   late int _remainingSeconds; // Sisa waktu dalam detik.
//   bool _isRunning = false;

//   @override
//   void initState() {
//     super.initState();
//     // Panggil fungsi reset saat halaman pertama kali dibuka untuk mengatur waktu awal.
//     _resetTimer();
//   }

//   @override
//   void dispose() {
//     // Ini sangat penting! Batalkan timer saat widget dihancurkan
//     // untuk mencegah memory leak dan error.
//     _timer?.cancel();
//     super.dispose();
//   }

//   // --- LOGIKA TIMER ---

//   // Mengatur ulang timer ke kondisi awal sesuai sesi yang dipilih.
//   void _resetTimer() {
//     // Hentikan timer yang mungkin sedang berjalan.
//     _timer?.cancel();
//     setState(() {
//       // Atur durasi total dan sisa waktu berdasarkan sesi yang aktif.
//       _totalSeconds = _getDurationForSession(_selectedSession).inSeconds;
//       _remainingSeconds = _totalSeconds;
//       _isRunning = false;
//     });
//   }

//   // Memulai atau melanjutkan timer.
//   void _startTimer() {
//     // Jika sudah berjalan atau waktu sudah habis, jangan lakukan apa-apa.
//     if (_isRunning || _remainingSeconds == 0) return;

//     setState(() {
//       _isRunning = true;
//     });

//     // Buat timer yang akan menjalankan kode di dalamnya setiap 1 detik.
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         // Jika waktu masih ada, kurangi 1 detik.
//         setState(() {
//           _remainingSeconds--;
//         });
//       } else {
//         // Jika waktu habis, hentikan timer.
//         _stopTimer(isCompleted: true);
//       }
//     });
//   }

//   // Menghentikan atau menjeda timer.
//   void _stopTimer({bool isCompleted = false}) {
//     _timer?.cancel();
//     setState(() {
//       _isRunning = false;
//       // Jika waktu habis, kita bisa tambahkan logika lain,
//       // seperti otomatis pindah ke sesi istirahat.
//       if (isCompleted) {
//         _skipToNextSession(); // Otomatis pindah sesi saat waktu habis
//       }
//     });
//   }

//   // FUNGSI BARU: Logika untuk pindah ke sesi berikutnya.
//   void _skipToNextSession() {
//     setState(() {
//       // Logika siklus: Pomodoro -> Istirahat Pendek -> Istirahat Panjang -> kembali ke Pomodoro
//       switch (_selectedSession) {
//         case PomodoroSession.pomodoro:
//           _selectedSession = PomodoroSession.shortBreak;
//           break;
//         case PomodoroSession.shortBreak:
//           _selectedSession = PomodoroSession.longBreak;
//           break;
//         case PomodoroSession.longBreak:
//           _selectedSession = PomodoroSession.pomodoro;
//           break;
//       }
//     });
//     // Setelah sesi diubah, reset timer agar waktu yang baru diterapkan.
//     _resetTimer();
//   }

//   // --- HELPER FUNCTION ---

//   // Mengembalikan objek Duration berdasarkan sesi yang dipilih.
//   Duration _getDurationForSession(PomodoroSession session) {
//     switch (session) {
//       case PomodoroSession.pomodoro:
//         return const Duration(minutes: 25);
//       case PomodoroSession.shortBreak:
//         return const Duration(minutes: 5);
//       case PomodoroSession.longBreak:
//         return const Duration(minutes: 15);
//     }
//   }

//   // Mengubah detik (integer) menjadi format string "mm:ss".
//   String _formatTime(int seconds) {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$remainingSeconds';
//   }

//   // Menampilkan panel tugas dari bawah (khusus mobile).
//   void _showTasksBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return FractionallySizedBox(
//           heightFactor: 0.6,
//           child: _buildTaskPanel(),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 900;

//     return Scaffold(
//       appBar: AdaptiveAppBar(title: const Text('Fokus Pomodoro')),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (isDesktop) {
//             return Row(
//               children: [
//                 Expanded(flex: 2, child: _buildTimerView(isDesktop: true)),
//                 const VerticalDivider(width: 1),
//                 Expanded(flex: 1, child: _buildTaskPanel()),
//               ],
//             );
//           }
//           return _buildTimerView(isDesktop: false);
//         },
//       ),
//     );
//   }

//   // Widget untuk membangun tampilan utama timer.
//   Widget _buildTimerView({required bool isDesktop}) {
//     // Hitung persentase progres untuk CircularProgressIndicator.
//     final double progress = _totalSeconds > 0
//         ? _remainingSeconds / _totalSeconds
//         : 1.0;

//     return Column(
//       children: [
//         const SizedBox(height: 24),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             alignment: WrapAlignment.center,
//             children: [
//               _buildSessionButton(
//                 PomodoroSession.pomodoro,
//                 Icons.work_outline,
//                 'Pomodoro',
//               ),
//               _buildSessionButton(
//                 PomodoroSession.shortBreak,
//                 Icons.free_breakfast_outlined,
//                 'Pendek',
//               ),
//               _buildSessionButton(
//                 PomodoroSession.longBreak,
//                 Icons.bedtime_outlined,
//                 'Panjang',
//               ),
//             ],
//           ),
//         ),
//         const Spacer(),
//         // REVISI TOTAL: Menggunakan Stack untuk menumpuk progress indicator dan teks.
//         SizedBox(
//           width: 260, // Sedikit lebih besar untuk memberi ruang pada outline
//           height: 260,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // 1. Progress Indicator sebagai outline dinamis.
//               CircularProgressIndicator(
//                 value: progress,
//                 strokeWidth: 8,
//                 backgroundColor: Theme.of(
//                   context,
//                 ).dividerColor.withOpacity(0.5),
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               // 2. Teks waktu di tengah.
//               Center(
//                 child: Text(
//                   _formatTime(_remainingSeconds),
//                   style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 60),
//         // REVISI: Tombol aksi sekarang dibuat lebih dinamis.
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Tombol Reset yang muncul/hilang dengan animasi.
//             AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _isRunning ? 1.0 : 0.0, // Muncul jika timer berjalan
//               child: IconButton(
//                 icon: const Icon(Icons.refresh),
//                 iconSize: 32,
//                 // Tombol tidak bisa di-tap jika tidak terlihat.
//                 onPressed: _isRunning ? _resetTimer : null,
//               ),
//             ),
//             const SizedBox(width: 20),
//             FloatingActionButton.large(
//               onPressed: () {
//                 if (_isRunning) {
//                   _stopTimer();
//                 } else {
//                   _startTimer();
//                 }
//               },
//               child: Icon(
//                 _isRunning ? Icons.pause : Icons.play_arrow,
//                 size: 48,
//               ),
//             ),
//             const SizedBox(width: 20),
//             // Tombol Next yang muncul/hilang dengan animasi.
//             AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: _isRunning ? 1.0 : 0.0, // Muncul jika timer berjalan
//               child: IconButton(
//                 icon: const Icon(Icons.skip_next),
//                 iconSize: 32,
//                 // Tombol tidak bisa di-tap jika tidak terlihat.
//                 onPressed: _isRunning ? _skipToNextSession : null,
//               ),
//             ),
//           ],
//         ),
//         const Spacer(),
//         if (!isDesktop)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16.0),
//             child: TextButton.icon(
//               onPressed: () => _showTasksBottomSheet(context),
//               icon: const Icon(Icons.list_alt_rounded),
//               label: const Text('Tugas Sesi Ini'),
//             ),
//           ),
//       ],
//     );
//   }

//   // Widget untuk membangun panel tugas.
//   Widget _buildTaskPanel() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Tugas Untuk Sesi Ini',
//             style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               children: [
//                 CheckboxListTile(
//                   title: const Text('Siapkan presentasi'),
//                   value: false,
//                   onChanged: (v) {},
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Follow up client A'),
//                   value: false,
//                   onChanged: (v) {},
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           OutlinedButton.icon(
//             onPressed: () {},
//             icon: const Icon(Icons.add),
//             label: const Text('Tambah Tugas'),
//             style: OutlinedButton.styleFrom(
//               minimumSize: const Size.fromHeight(50),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget helper untuk membangun tombol pilihan sesi.
//   Widget _buildSessionButton(
//     PomodoroSession session,
//     IconData icon,
//     String label,
//   ) {
//     final isSelected = _selectedSession == session;
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedSession = session;
//         });
//         _resetTimer();
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? Theme.of(context).colorScheme.primary
//                 : Theme.of(context).dividerColor,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected
//                   ? Theme.of(context).colorScheme.primary
//                   : Theme.of(context).iconTheme.color,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
