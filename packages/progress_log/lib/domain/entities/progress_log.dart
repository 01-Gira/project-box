import 'package:equatable/equatable.dart';

class ProgressLog extends Equatable {
  final int id;
  final String? imagePath;
  final String? logText;
  final DateTime? logDate;

  const ProgressLog({
    required this.id,
    this.imagePath,
    this.logText,
    this.logDate,
  });

  @override
  List<Object?> get props => [id, imagePath, logText, logDate];
}
