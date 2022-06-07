class Semester {
  final String year;
  final String number;
  final int isEnded;
  const Semester({required this.year, required this.number, required this.isEnded});

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(year: json['year'], number: json['number'], isEnded:json['isEnded']);
  }
}
