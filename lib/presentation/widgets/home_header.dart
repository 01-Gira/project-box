import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// Tidak perlu 'package:flutter/widgets.dart'; karena sudah termasuk di material.dart

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  // Fungsi untuk mendapatkan sapaan dinamis kita pindahkan ke sini
  // agar widget ini mandiri.
  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return l10n.goodMorning;
    }
    if (hour < 15) {
      return l10n.goodAfternoon;
    }
    if (hour < 19) {
      // Waktu WIB saat ini adalah 16:54, jadi ini yang akan tampil
      return l10n.goodEvening;
    }
    return l10n.goodNight;
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data tema dari context untuk konsistensi
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting(l10n)} Gira', // Menggunakan fungsi sapaan dinamis
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7), // Warna yang adaptif
          ),
        ),
        Text(
          l10n.homeTagline, // Anda bisa mengganti dengan nama pengguna
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
