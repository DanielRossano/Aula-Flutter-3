class Tip {
  final int? id;
  final double billAmount;
  final double tipAmount;
  final double percentage;

  Tip({this.id, required this.billAmount, required this.tipAmount, required this.percentage});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'billAmount': billAmount,
      'tipAmount': tipAmount,
      'percentage': percentage,
    };
  }

  factory Tip.fromMap(Map<String, dynamic> map) {
    return Tip(
      id: map['id'],
      billAmount: map['billAmount'],
      tipAmount: map['tipAmount'],
      percentage: map['percentage'],
    );
  }
}
