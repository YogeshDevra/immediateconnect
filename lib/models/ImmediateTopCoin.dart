// ignore_for_file: file_names

class ImmediateTopCoin {
  String? immTopDiffRate;
  double? immTopRate;
  int? immTopCoinId;
  String? immTopName;

  ImmediateTopCoin({this.immTopDiffRate, this.immTopRate, this.immTopCoinId, this.immTopName});

  ImmediateTopCoin.fromJson(Map<String, dynamic> json) {
    immTopDiffRate = json['diffRate'];
    immTopRate = json['rate'];
    immTopCoinId = json['bitcoinId'];
    immTopName = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diffRate'] = immTopDiffRate;
    data['rate'] = immTopRate;
    data['bitcoinId'] = immTopCoinId;
    data['name'] = immTopName;
    return data;
  }
}