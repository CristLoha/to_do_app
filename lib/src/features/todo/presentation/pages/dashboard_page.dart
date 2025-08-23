import 'dart:math'; // Import untuk menggunakan fungsi random

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/src/features/todo/presentation/widgets/adaptive_app_bar.dart';

// Enum untuk filter waktu, ditaruh di sini agar relevan dengan halaman ini.
enum ReportTimeRange { week, month, year }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // State untuk menyimpan filter waktu yang sedang aktif.
  ReportTimeRange _selectedTimeRange = ReportTimeRange.week;

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk statistik, nanti ini akan dari BLoC.
    const int hoursFocused = 12;
    const int tasksCompleted = 28;
    const int dayStreak = 3;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AdaptiveAppBar(title: const Text('Laporan Produktivitas')),
      // Menggunakan struktur CustomScrollView yang sama persis dengan HomePage
      // untuk memastikan tata letak dan padding yang konsisten.
      body: CustomScrollView(
        slivers: [
          // REVISI: Seluruh SliverPadding ini sekarang hanya akan dibuat
          // jika tampilan adalah desktop. Ini akan menghilangkan judul duplikat di mobile.
          if (isDesktop)
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 24.0,
                right: 24.0,
                bottom: 16.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Produktivitas',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implementasi logika export ke Excel/Docs.
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Sliver 2: Konten utama dengan padding horizontal yang konsisten.
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Bagian Ringkasan Aktivitas
                _buildSectionTitle('Ringkasan Aktivitas'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      'Jam Fokus',
                      hoursFocused.toString(),
                      Icons.hourglass_bottom_rounded,
                      Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Tugas Selesai',
                      tasksCompleted.toString(),
                      Icons.task_alt_rounded,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Streak Harian',
                      dayStreak.toString(),
                      Icons.local_fire_department_rounded,
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Bagian Grafik Jam Fokus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle('Jam Fokus'),
                    // Tombol filter waktu
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTimeFilterChip(ReportTimeRange.week, 'Minggu'),
                        _buildTimeFilterChip(ReportTimeRange.month, 'Bulan'),
                        _buildTimeFilterChip(ReportTimeRange.year, 'Tahun'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      // REVISI: Memanggil grafik yang adaptif
                      child: isDesktop
                          ? _buildDummyLineChart(context)
                          : _buildDummyBarChart(context),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk judul setiap bagian.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  // Widget helper untuk kartu statistik.
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat chip filter waktu yang interaktif.
  Widget _buildTimeFilterChip(ReportTimeRange range, String label) {
    final isSelected = _selectedTimeRange == range;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Memanggil setState untuk memperbarui UI dan menyimpan pilihan baru.
          setState(() {
            _selectedTimeRange = range;
            // TODO: Di sini kamu akan memanggil fungsi untuk memuat ulang data grafik
            // sesuai dengan filter waktu yang baru (_selectedTimeRange).
          });
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }

  // --- GRAFIK DUMMY ---

  // Grafik Bar Sederhana (untuk Mobile)
  Widget _buildDummyBarChart(BuildContext context) {
    List<double> barHeights;
    List<String> labels;
    final random = Random();

    switch (_selectedTimeRange) {
      case ReportTimeRange.week:
        barHeights = List.generate(7, (_) => random.nextDouble());
        labels = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
        break;
      case ReportTimeRange.month:
        barHeights = List.generate(4, (_) => random.nextDouble());
        labels = ['W1', 'W2', 'W3', 'W4'];
        break;
      case ReportTimeRange.year:
        barHeights = List.generate(12, (_) => random.nextDouble());
        labels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(labels.length, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: FractionallySizedBox(
                heightFactor: barHeights[index].clamp(0.1, 1.0),
                child: Container(
                  width: 12, // Dibuat lebih ramping untuk mobile
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(labels[index]),
          ],
        );
      }),
    );
  }

  // Grafik Garis (untuk Desktop/Website)
  Widget _buildDummyLineChart(BuildContext context) {
    // Nanti ini bisa diganti dengan package seperti fl_chart
    return CustomPaint(
      painter: _LineChartPainter(
        context: context,
        timeRange: _selectedTimeRange,
      ),
      size: Size.infinite,
    );
  }
}

// --- PAINTER UNTUK GRAFIK GARIS DUMMY ---
// Ini adalah class helper untuk menggambar grafik secara manual.
class _LineChartPainter extends CustomPainter {
  final BuildContext context;
  final ReportTimeRange timeRange;

  _LineChartPainter({required this.context, required this.timeRange});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    List<double> dataPoints;
    List<String> labels;

    // Generate data dan label berdasarkan filter waktu
    switch (timeRange) {
      case ReportTimeRange.week:
        dataPoints = List.generate(7, (_) => random.nextDouble());
        labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
        break;
      case ReportTimeRange.month:
        dataPoints = List.generate(4, (_) => random.nextDouble());
        labels = ['Minggu 1', 'Minggu 2', 'Minggu 3', 'Minggu 4'];
        break;
      case ReportTimeRange.year:
        dataPoints = List.generate(12, (_) => random.nextDouble());
        labels = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Ags',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        break;
    }

    final paint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (dataPoints.length - 1);

    // Pindahkan path ke titik awal
    path.moveTo(0, size.height - (dataPoints[0] * size.height));

    // Gambar garis yang menghubungkan setiap titik data
    for (int i = 1; i < dataPoints.length; i++) {
      path.lineTo(i * stepX, size.height - (dataPoints[i] * size.height));
    }

    canvas.drawPath(path, paint);

    // Gambar label di sumbu X
    for (int i = 0; i < labels.length; i++) {
      final textSpan = TextSpan(
        text: labels[i],
        style: Theme.of(context).textTheme.bodySmall,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * stepX - (textPainter.width / 2), size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
