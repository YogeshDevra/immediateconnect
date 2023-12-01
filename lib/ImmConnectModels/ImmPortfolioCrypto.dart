
class ImmPortfolioCrypto {
  int? _id;
  String? _name;
  double? _rate;
  String? _perRate;
  double? _rateDuringAdding;
  double? _numberOfCoins;
  double? _totalValue;

  ImmPortfolioCrypto(this._id, this._name, this._rate, this._perRate, this._rateDuringAdding,
      this._numberOfCoins, this._totalValue);
  int get id => _id!;
  String get name => _name!;
  double get rate => _rate!;
  String get perRate => _perRate!;
  double get rateDuringAdding => _rateDuringAdding!;
  double get numberOfCoins => _numberOfCoins!;
  double get totalValue => _totalValue!;

  ImmPortfolioCrypto.map(dynamic obj) {
    _id = obj['id'];
    _name=obj['name'] ;
    _rate =  obj['rate'];
    _perRate =  obj['perRate'];
    _rateDuringAdding= obj['rate_during_adding'] ;
    _numberOfCoins = obj['coins_quantity'];
    _totalValue= obj['total_value'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) { map['id'] = _id; }
    map['name'] = _name;
    map['rate'] = _rate;
    map['perRate'] = _perRate;
    map['rate_during_adding'] = _rateDuringAdding;
    map['coins_quantity'] = _numberOfCoins;
    map['total_value'] = _numberOfCoins;
    return map;
  }

  ImmPortfolioCrypto.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name=map['name'] ;
    _rate =  map['rate'];
    _perRate =  map['perRate'];
    _rateDuringAdding= map['rate_during_adding'] ;
    _numberOfCoins = map['coins_quantity'] ;
    _totalValue= map['total_value'];
  }
}