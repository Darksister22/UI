class Instructors {
  final int id;
  final String nameAr;
  final String nameEn;

  const Instructors({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Instructors.fromJson(Map<String, dynamic> json) {
    return Instructors(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}
