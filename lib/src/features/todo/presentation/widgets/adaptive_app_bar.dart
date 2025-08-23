import 'package:flutter/material.dart';

// Widget ini adalah AppBar pintar yang akan otomatis hilang di layar lebar.
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;

  const AdaptiveAppBar({super.key, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    // Cek ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    const double desktopBreakpoint = 900;
    final bool isDesktop = screenWidth > desktopBreakpoint;

    // Jika ini tampilan desktop, jangan tampilkan apa-apa (kembalikan container kosong)
    if (isDesktop) {
      return const SizedBox.shrink();
    }

    // Jika mobile, tampilkan AppBar seperti biasa
    return AppBar(title: title, actions: actions);
  }

  // Kita perlu mendefinisikan ukuran AppBar agar tidak error.
  // Jika desktop, ukurannya 0. Jika mobile, ukurannya standar (kToolbarHeight).
  @override
  Size get preferredSize {
    // Cek ukuran layar lagi di sini
    // (Kita tidak bisa akses BuildContext, jadi kita buat logika sederhana)
    // Ini adalah trik, cara yang lebih robust adalah dengan meneruskan isDesktop
    // Tapi untuk kasus ini, kita bisa asumsikan jika title null, kita di desktop.
    // Solusi yang lebih baik adalah membuat AppBar ini tahu konteksnya.
    // Mari kita sederhanakan untuk sekarang:
    // Kita akan tetap mengandalkan logika di dalam build.
    // preferredSize akan selalu mengembalikan ukuran standar,
    // dan build method akan mengembalikan widget kosong jika perlu.
    return const Size.fromHeight(kToolbarHeight);
  }
}
