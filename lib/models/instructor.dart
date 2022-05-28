class Instructor {
  final int id;
  final String nameAr;
  final String nameEn;

  const Instructor({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}
