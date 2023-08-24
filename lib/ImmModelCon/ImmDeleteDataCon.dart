// ignore_for_file: unnecessary_this, prefer_collection_literals, file_names

class ImmDeleteDataCon {
  int? _id;
  String? _name;
  String? _symbol;
  double? _rateDuringAdding;
  double? _numberOfCoins;
  double? _totalValue;
  int? _datetime;

  ImmDeleteDataCon(this._id, this._name, this._rateDuringAdding, this._numberOfCoins,
      this._symbol, this._totalValue, this._datetime);

  int get id => _id!;

  String get name => _name!;

  String get symbol => _symbol!;

  double get rateDuringAdding => _rateDuringAdding!;

  double get numberOfCoins => _numberOfCoins!;

  double get totalValue => _totalValue!;

  int get datetime => _datetime!;

  ImmDeleteDataCon.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._symbol = obj['symbol'];
    this._rateDuringAdding = obj['rate_during_adding'];
    this._numberOfCoins = obj['coins_quantity'];
    this._totalValue = obj['delete_total_value'];
    this._datetime = obj['date_time'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['symbol'] = _symbol;
    map['rate_during_adding'] = _rateDuringAdding;
    map['coins_quantity'] = _numberOfCoins;
    map['delete_total_value'] = _numberOfCoins;
    map['date_time'] = _datetime;

    return map;
  }

  ImmDeleteDataCon.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._symbol = map['symbol'];
    this._rateDuringAdding = map['rate_during_adding'];
    this._numberOfCoins = map['coins_quantity'];
    this._totalValue = map['delete_total_value'];
    this._datetime = map['date_time'];
  }
}
