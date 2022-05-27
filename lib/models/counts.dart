class Counts {
  final int stucount;
  final int inscount;
  final int crscount;
  final String year;
  final String number;

  const Counts(
      {required this.stucount,
      required this.inscount,
      required this.crscount,
      required this.year,
      required this.number});

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
        stucount: json['students'],
        inscount: json['instuctors'],
        crscount: json['courses'],
        year: json['year'],
        number: json['number']);
  }
}
