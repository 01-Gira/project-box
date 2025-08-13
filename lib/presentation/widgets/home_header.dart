import 'package:flutter/material.dart';
// Tidak perlu 'package:flutter/widgets.dart'; karena sudah termasuk di material.dart

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  // Fungsi untuk mendapatkan sapaan dinamis kita pindahkan ke sini
  // agar widget ini mandiri.
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi,';
    }
    if (hour < 15) {
      return 'Selamat Siang,';
    }
    if (hour < 19) {
      // Waktu WIB saat ini adalah 16:54, jadi ini yang akan tampil
      return 'Selamat Sore,';
    }
    return 'Selamat Malam,';
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data tema dari context untuk konsistensi
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting()} Gira', // Menggunakan fungsi sapaan dinamis
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7), // Warna yang adaptif
          ),
        ),
        Text(
          'Mari Berkarya!', // Anda bisa mengganti dengan nama pengguna
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme
                .onSurface, // Warna yang adaptif (hitam di light, putih di dark)
          ),
        ),
      ],
    );
  }
}
