

class Student {
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

  const Student({
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
  });
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      level: json['level'],
      year: json['year'],
      avg1: json['stu_avg1'],
      avg2: json['stu_avg2'],
      avg3: json['stu_avg3'],
      avg4: json['stu_avg4'],
      avg5: json['stu_avg5'],
      avg6: json['stu_avg6'],
      avg7: json['stu_avg7'],
      avg8: json['stu_avg8'],
      avg9: json['stu_avg9'],
      avg10: json['stu_avg10'],
      note: json['note'],
    );
  }
}

/*
Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameAr'] = this.nameAr;
    data['nameEn'] = this.nameEn;
    data['level'] = this.level;
    data['avg1'] = this.avg1;
    data['avg2'] = this.avg1;
    data['avg3'] = this.avg1;
    data['avg4'] = this.avg7;
    data['avg5'] = this.avg6;
    data['avg6'] = this.avg6;
    data['avg7'] = this.avg7;
    data['avg8'] = this.avg8;
    data['avg9'] = this.avg9; 
    data['avg10'] = this.avg10;
    if (this.question != null) {
      data['question'] = this.question.map((v) => v.toJson()).toList();
    }
    return data;
  }*/