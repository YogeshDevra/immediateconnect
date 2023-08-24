// ignore_for_file: unnecessary_this, prefer_collection_literals, file_names

class ImmPortDataCon {
  int? _id;
  String? _name;
  String? _symbol;
  String? _icon;
  double? _rateDuringAdding;
  double? _numberOfCoins;
  double? _totalValue;

  ImmPortDataCon(this._id, this._name, this._rateDuringAdding, this._symbol,
      this._icon, this._numberOfCoins, this._totalValue);

  int get id => _id!;

  String get name => _name!;
  String get symbol => _symbol!;
  String get icon => _icon!;

  double get rateDuringAdding => _rateDuringAdding!;

  double get numberOfCoins => _numberOfCoins!;

  double get totalValue => _totalValue!;

  ImmPortDataCon.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._symbol = obj['symbol'];
    this._icon = obj['icon'];
    this._rateDuringAdding = obj['rate_during_adding'];
    this._numberOfCoins = obj['coins_quantity'];
    this._totalValue = obj['total_value'];
  }

  Map<String, dynamic> toMap() {
    var map =  Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['symbol'] = _symbol;
    map['icon'] = _icon;
    map['rate_during_adding'] = _rateDuringAdding;
    map['coins_quantity'] = _numberOfCoins;
    map['total_value'] = _numberOfCoins;

    return map;
  }

  ImmPortDataCon.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._symbol = map['symbol'];
    this._icon = map['icon'];
    this._rateDuringAdding = map['rate_during_adding'];
    this._numberOfCoins = map['coins_quantity'];
    this._totalValue = map['total_value'];
  }
}
