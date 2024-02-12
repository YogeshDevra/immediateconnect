class Cryptodata {
  final int? bitcoinId;
  final String? fullName;
  final String? icon;
  final String? symbol;
  final double? rate;
  final String? trend;
  double? close;
  double? open;
  double? volume;
  String? diffRate;
  double? high;
  double? low;

  // All dogs start out at 10, because they're good dogs.

  Cryptodata({
    this.bitcoinId,
    this.fullName,
    this.icon,
    this.symbol,
    this.rate,
    this.trend,
    this.close,
    this.open,
    this.volume,
    this.diffRate,
    this.high,
    this.low
  });
  factory Cryptodata.fromJson(Map<String, dynamic> json) {
    return Cryptodata(
      bitcoinId: json["bitcoinId"],
      fullName: json["fullName"],
      icon: json["icon"],
      symbol: json["symbol"],
      rate: json["rate"],
      trend: json["trend"],
      open: json["open"],
      close: json["close"],
      volume: json["volume"],
      diffRate: json["diffRate"],
      high: json["high"],
      low: json["low"]
    );
  }
}
