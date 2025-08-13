import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/domain/enitites/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isSelected;

  const ProjectCard({
    super.key,
    required this.project,
    this.isSelected = false, // Default-nya tidak terpilih
  });

  @override
  Widget build(BuildContext context) {
    final String? coverImage = project.coverImage;
    final bool hasImage = coverImage != null && coverImage.isNotEmpty;
    final int completedTasks = project.completedTasks ?? 0;
    final int totalTasks = project.totalTasks ?? 0;
    final double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    ImageProvider? backgroundImage;
    if (hasImage) {
      backgroundImage = FileImage(File(coverImage));
    }

    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Stack(
        children: [
          // Background
          Positioned.fill(
            child: hasImage
                ? Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: backgroundImage!,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey.shade400,
                          Colors.blueGrey.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressIndicator(progress),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(project.name),
                      const SizedBox(height: 4),
                      _buildSubtitle(completedTasks, totalTasks),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- PERUBAHAN: Overlay saat item dipilih ---
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.check_circle, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        shadows: [Shadow(blurRadius: 2.0, color: Colors.black54)],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(int completed, int total) {
    return Text(
      '$completed dari $total tugas selesai',
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 12,
        shadows: const [Shadow(blurRadius: 1.0, color: Colors.black54)],
      ),
    );
  }
}
