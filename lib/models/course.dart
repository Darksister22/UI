import 'package:schoolmanagement/models/instructor.dart';
import 'package:schoolmanagement/models/student.dart';

class Course {
  final int id;
  final String level;
  final String year;
  final String nameAr;
  final String nameEn;
  final String code;
  final int success;
  final int unit;
//  final Instructor instructor;
  final List<Student>? student;
  final List<Student>? carries;
  const Course(
      {required this.id,
      required this.level,
      required this.year,
      required this.nameAr,
      required this.nameEn,
      required this.code,
      required this.success,
      required this.unit,
      required this.student,
      //    required this.instructor,
      required this.carries});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        code: json['code'],
        success: json['success'],
        unit: json['unit'],
        student:
            (json["students"] as List).map((e) => Student.fromJson(e)).toList(),
        carries: (json["students_carry"] as List)
            .map((e) => Student.fromJson(e))
            .toList(),
        // instructor:
        level: json['level'],
        year: json['year']);
  }
}
