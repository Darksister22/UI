class Help {
  final String amt;
  final String source;
  const Help({required this.amt, required this.source});

  factory Help.fromJson(Map<String, dynamic> json) {
    return Help(amt: json['amt'], source: json['source']);
  }
}
