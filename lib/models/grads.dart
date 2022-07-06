class Grad {
  final int id;
  final String nameAr;
  final String nameEn;
  final String level;
  final String year;
  final String? avg1;
  final String? avg2;
  final String? avg3;
  final String? avg4;
  final String? avg5;
  final String? avg6;
  final String? avg7;
  final String? avg8;
  final String? avg9;
  final String? avg10;
  final String? note;
  final String? avgfinal;
  final String? summer;

  const Grad({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.level,
    required this.year,
    required this.avg1,
    required this.avg2,
    required this.avg3,
    required this.avg4,
    required this.avg5,
    required this.avg6,
    required this.avg7,
    required this.avg8,
    required this.avg9,
    required this.avg10,
    required this.note,
    required this.avgfinal,
    required this.summer,
  });
  factory Grad.fromJson(Map<String, dynamic> json) {
    return Grad(
      id: json['id'],
      summer: json['summer_deg'],
      avgfinal: json["avg_final"],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      level: json['level'],
      year: json['year'],
      avg1: json['avg1'],
      avg2: json['avg2'],
      avg3: json['avg3'],
      avg4: json['avg4'],
      avg5: json['avg5'],
      avg6: json['avg6'],
      avg7: json['avg7'],
      avg8: json['avg8'],
      avg9: json['avg9'],
      avg10: json['avg10'],
      note: json['note'],
    );
  }
}
