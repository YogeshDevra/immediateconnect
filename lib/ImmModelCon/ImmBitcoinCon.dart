// ignore_for_file: implementation_imports, non_constant_identifier_names, file_names

import 'package:candlesticks/src/models/candle.dart';

class ImmBitCoinCon {
  final int? id;
  final String? name;
  final double? changepct;
  final String? symbol;
  final double? rate;
  final String? diffRate;
  final String? icon;
  final List<dynamic>? historyRate;
  final String? date;
  final String? perRate;
  final double? high;
  final double? low;
  final double? cap;
  final double? volume;
  final double? open;
  final double? close;

  ImmBitCoinCon({
    this.id,
    this.name,
    this.changepct,
    this.symbol,
    this.rate,
    this.date,
    this.diffRate,
    this.historyRate,
    this.perRate,
    this.high,
    this.low,
    this.cap,
    this.volume,
    this.open,
    this.close,
    this.icon,
  });
  factory ImmBitCoinCon.fromJson(Map<String, dynamic> json) {
    return ImmBitCoinCon(
      id: json["id"],
      name: json["name"],
      changepct: json["change_pct"],
      symbol: json["symbol"],
      rate: json["rate"],
      date: json["date"],
      diffRate: json["diffRate"],
      historyRate: json["historyRate"],
      perRate: json["perRate"],
      high: json["high"],
      low: json["low"],
      cap: json["cap"],
      volume: json["volume"],
      open: json["open"],
      close: json["close"],
      icon: json["icon"],
    );
  }

  map(Candle Function(dynamic Bitcoin) param0) {}
}
