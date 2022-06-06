

class DegreeSingle {
  final int? id;
  final int? student;
  final int? course;
  final String? fourty;
  final String? sixty1;
  final String? sixty2;
  final String? sixty3;
  final String? final1;
  final String? final2;
  final String? final3;
  final String? approx;
  final String? sts;

  const DegreeSingle({
    this.id,
    this.student,
    this.course,
    this.fourty,
    this.sixty1,
    this.sixty2,
    this.sixty3,
    this.final1,
    this.final2,
    this.final3,
    this.approx,
    this.sts,
  });

  factory DegreeSingle.fromJson(Map<String, dynamic> json) {
    return DegreeSingle(
      id: json['id'],
      student: json['student_id'],
      course: json['course_id'],
      fourty: json['fourty'],
      sixty1: json['sixty1'],
      sixty2: json['sixty2'],
      sixty3: json['sixty3'],
      final1: json['final1'],
      final2: json['final2'],
      final3: json['final3'],
      approx: json['approx'],
      sts: json['sts'],
      //  coursename: Course?.fromJson(json["courses"]),
      //  stuname: Student?.fromJson(json["student"])
    );
  }
}
