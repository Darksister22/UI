class HelpStu {
  final int amt;
  final String source;

  const HelpStu({required this.amt, required this.source});

  factory HelpStu.fromJson(Map<String, dynamic> json) {
    return HelpStu(amt: json['amt'], source: json['source']);
  }
}
