class ImmCrypto{
  final String? date;
  final double? changepct;
  final String? symbol;
  final double? change;
  final int? bitId;
  final String? icon;
  final String? differRate;
  final String? perRate;
  final String? fullName;
  final double? volume;
  final double? high;
  final double? cap;
  final double? low;
  final double? rate;
  final String? name;
  final double? close;
  final double? open;

  ImmCrypto({
    this.date,
    this.changepct,
    this.symbol,
    this.change,
    this.bitId,
    this.icon,
    this.differRate,
    this.perRate,
    this.fullName,
    this.volume,
    this.high,
    this.cap,
    this.low,
    this.rate,
    this.name,
    this.close,
    this.open,
  });
  factory ImmCrypto.fromJson(Map<String, dynamic> json) {
    return ImmCrypto(
      date: json["date"] ?? "",
      changepct: json["change_pct"] ?? 0.0,
      symbol: json["symbol"] ?? "",
      change: json["change"] ?? 0.0,
      bitId: json["bitcoinId"] ?? 0,
      icon: json["icon"] ?? "",
      differRate: json["diffRate"] ?? "",
      perRate: json["perRate"] ?? "0.0",
      fullName: json["fullName"] ?? "",
      volume: json["volume"] ?? 0.0,
      high: json["high"] ?? 0.0,
      cap: json["cap"] ?? 0.0,
      low: json["low"] ?? 0.0,
      rate: json["rate"] ?? 0.0,
      name: json["name"] ?? "",
      close: json["close"] ?? 0.0,
      open: json["open"] ?? 0.0,
    );
  }
}