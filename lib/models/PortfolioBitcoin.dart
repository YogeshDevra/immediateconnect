class PortfolioBitcoin {
  int? _id;
  String? _name;
  String? _fullName;
  String? _icon;
  String? _diffRate;
  double? _rate;
  double? _rateDuringAdding;
  double? _numberOfCoins;
  double? _totalValue;


  PortfolioBitcoin(this._id, this._name, this._fullName, this._icon, this._diffRate, this._rate,
      this._rateDuringAdding, this._numberOfCoins, this._totalValue);
  int get id => _id!;
  String get name => _name!;
  String get fullName => _fullName!;
  String get icon => _icon!;
  String get diffRate => _diffRate!;
  double get rate => _rate!;
  double get rateDuringAdding => _rateDuringAdding!;
  double get numberOfCoins => _numberOfCoins!;
  double get totalValue => _totalValue!;

  PortfolioBitcoin.map(dynamic obj) {
    _id = obj['id'];
    _name = obj['name'];
    _fullName = obj['fullName'];
    _icon = obj['icon'];
    _diffRate = obj['diffRate'];
    _rate =  obj['rate'];
    _rateDuringAdding = obj['rate_during_adding'];
    _numberOfCoins = obj['coins_quantity'];
    _totalValue = obj['total_value'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['fullName'] = _fullName;
    map['icon'] = _icon;
    map['diffRate'] = _diffRate;
    map['rate'] = _rate;
    map['rate_during_adding'] = _rateDuringAdding;
    map['coins_quantity'] = _numberOfCoins;
    map['total_value'] = _totalValue;
    return map;
  }

  PortfolioBitcoin.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _fullName = map['fullName'];
    _icon = map['icon'];
    _diffRate = map['diffRate'];
    _rate =  map['rate'];
    _rateDuringAdding = map['rate_during_adding'];
    _numberOfCoins = map['coins_quantity'];
    _totalValue = map['total_value'];
  }
}
