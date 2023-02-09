// ignore_for_file: file_names

class ImmediateBitcoin {
  final int? immBitId;
  final String? immBitName;
  final double? immBitRate;
  final String? immBitDiffRate;
  final List<dynamic>? immBitHistoryRate;
  final String? immBitDate;
  final String? immBitPerRate;

  ImmediateBitcoin(
      {this.immBitId, this.immBitName, this.immBitRate, this.immBitDate, this.immBitDiffRate, this.immBitHistoryRate, this.immBitPerRate});

  factory ImmediateBitcoin.fromJson(Map<String, dynamic> json) {
    return ImmediateBitcoin(
      immBitId: json["id"],
      immBitName: json["name"],
      immBitRate: json["rate"],
      immBitDate: json["date"],
      immBitDiffRate: json["diffRate"],
      immBitHistoryRate: json["historyRate"],
      immBitPerRate: json["perRate"],
    );
  }
}
