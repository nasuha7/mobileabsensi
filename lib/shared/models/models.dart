import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class Course {
  final String id, name, day, time, room;
  const Course({
    required this.id,
    required this.name,
    required this.day,
    required this.time,
    required this.room,
  });
}

enum AttendStatus { hadir, izin, tidak }

extension AttendStatusX on AttendStatus {
  String get label => switch (this) {
        AttendStatus.hadir => 'HADIR',
        AttendStatus.izin => 'IZIN',
        AttendStatus.tidak => 'TIDAK HADIR',
      };
  Color get color => switch (this) {
        AttendStatus.hadir => AppColors.success,
        AttendStatus.izin => AppColors.warning,
        AttendStatus.tidak => AppColors.danger,
      };
}

class AttendanceRecord {
  final String courseName;
  final DateTime date;
  final AttendStatus status;
  const AttendanceRecord({
    required this.courseName,
    required this.date,
    required this.status,
  });
}

class StudentAttendance {
  final String name;
  AttendStatus status;
  StudentAttendance(this.name, this.status);
}
