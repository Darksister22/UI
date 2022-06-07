import 'package:schoolmanagement/models/semseter.dart';
import 'package:schoolmanagement/models/student.dart';

import 'instructor.dart';

class Course {
  final int id;
  final String level;
  final String year;
  final String nameAr;
  final String nameEn;
  final String code;
  final int success;
  final int unit;
  final Instructor? instructor;

  Semester? sem;

  final List<Student>? student;
  final List<Student>? carries;
  Course({
    required this.id,
    required this.level,
    required this.year,
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.success,
    required this.unit,
    this.student,
    this.carries,
    this.instructor,
    this.sem,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    if (json["semester"] == null && json["instructor"] != null) {
      return Course(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        code: json['code'],
        success: json['success'],
        unit: json['unit'],
        student: (json["students"] as List?)
            ?.map((e) => Student.fromJson(e))
            .toList(),
        carries: (json["students_carry"] as List?)
            ?.map((e) => Student.fromJson(e))
            .toList(),
        level: json['level'],
        year: json['year'],
        instructor: Instructor.fromJson(json["instructor"]),
      );
    } else if (json["instructor"] == null && json["semester"] == null) {
      return Course(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        code: json['code'],
        success: json['success'],
        unit: json['unit'],
        level: json['level'],
        year: json['year'],
      );
    } else if (json["instructor"] == null && json["semester"] != null) {
      return Course(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        code: json['code'],
        success: json['success'],
        unit: json['unit'],
        level: json['level'],
        year: json['year'],
        sem: Semester.fromJson(json['semester']),
      );
    }
    return Course(
        id: 0,
        level: "level",
        year: "year",
        nameAr: "nameAr",
        nameEn: "nameEn",
        code: "code",
        success: 0,
        unit: 0);
  }
}
