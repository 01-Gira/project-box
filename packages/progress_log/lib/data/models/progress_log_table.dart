import 'package:equatable/equatable.dart';

import 'package:progress_log/domain/entities/progress_log.dart';

class ProgressLogTable extends Equatable {
  final int id;
  final String? imagePath;
  final String? logText;
  final int? logDate;

  const ProgressLogTable({
    required this.id,
    this.imagePath,
    this.logText,
    this.logDate,
  });

  factory ProgressLogTable.fromMap(Map<String, dynamic> map) =>
      ProgressLogTable(
        id: map['id'],
        imagePath: map['image_path'],
        logText: map['log_text'],
        logDate: map['log_date'],
      );

  Map<String, dynamic> toJson() => {
    'image_path': imagePath,
    'log_text': logText,
    'log_date': DateTime.now().millisecondsSinceEpoch,
  };

  factory ProgressLogTable.fromEntity(ProgressLog log) => ProgressLogTable(
    id: log.id,
    imagePath: log.imagePath,
    logText: log.logText,
    logDate: log.logDate?.millisecondsSinceEpoch,
  );

  ProgressLog toEntity() => ProgressLog(
    id: id,
    imagePath: imagePath,
    logText: logText,
    logDate: logDate != null
        ? DateTime.fromMillisecondsSinceEpoch(logDate!)
        : null,
  );

  @override
  List<Object?> get props => [id, imagePath, logText, logDate];
}
