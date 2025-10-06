class Datum {
  String? date;
  String? week;

  Datum({this.date, this.week});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json['date'] as String?,
        week: json['week'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'week': week,
      };
}
