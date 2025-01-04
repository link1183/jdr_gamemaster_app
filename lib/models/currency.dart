class Currency {
  final int copper;
  final int silver;
  final int electrum;
  final int gold;
  final int platinum;

  Currency(
      {required this.copper,
      required this.silver,
      required this.electrum,
      required this.gold,
      required this.platinum});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
        copper: json['cp'] as int,
        silver: json['sp'] as int,
        gold: json['gp'] as int,
        electrum: json['ep'] as int,
        platinum: json['pp'] as int);
  }
}
