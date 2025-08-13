import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_log/domain/entities/progress_log.dart'; // Sesuaikan path entitas Anda

class ProgressLogCard extends StatelessWidget {
  final ProgressLog log;

  const ProgressLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool hasImage = log.imagePath != null && log.imagePath!.isNotEmpty;
    final bool hasText = log.logText != null && log.logText!.isNotEmpty;
    // Buat tag yang unik untuk Hero animation
    final String heroTag = 'log_image_${log.id}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // --- PERUBAHAN UTAMA: Menggunakan Row untuk layout minimal ---
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thumbnail Gambar (jika ada) ---
            if (hasImage)
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman full screen saat gambar ditekan
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imagePath: log.imagePath!,
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: (log.imagePath!.startsWith('http'))
                          ? NetworkImage(log.imagePath!)
                          : FileImage(File(log.imagePath!)) as ImageProvider,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

            if (hasImage) const SizedBox(width: 12),

            // --- Konten Teks ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasText) Text(log.logText!, style: textTheme.bodyMedium),

                  if (hasText) const SizedBox(height: 8),

                  Text(
                    DateFormat('d MMMM yyyy, HH:mm').format(log.logDate!),
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET BARU UNTUK FULL SCREEN VIEWER ---
class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imagePath.startsWith('http');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Image(
              image: isNetworkImage
                  ? NetworkImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
