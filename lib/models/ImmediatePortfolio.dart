// ignore_for_file: file_names

class ImmediatePortfolio {
  int? _immPortId;
  String? _immPortName;
  double? _immPortRate;
  double? _immPortRateDuringAdding;
  double? _immPortNumberOfCoins;
  double? _immPortTotalValue;


  ImmediatePortfolio(this._immPortId, this._immPortName, this._immPortRate, this._immPortRateDuringAdding,
      this._immPortNumberOfCoins, this._immPortTotalValue);

  int get id => _immPortId!;
  String get name => _immPortName!;
  double get rate => _immPortRate!;
  double get rateDuringAdding => _immPortRateDuringAdding!;
  double get numberOfCoins => _immPortNumberOfCoins!;
  double get totalValue => _immPortTotalValue!;

  ImmediatePortfolio.map(dynamic obj) {
    _immPortId = obj['id'];
    _immPortName=obj['name'] ;
    _immPortRate =  obj['rate'];
    _immPortRateDuringAdding= obj['rate_during_adding'] ;
    _immPortNumberOfCoins = obj['coins_quantity'];
    _immPortTotalValue= obj['total_value'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_immPortId != null) {map['id'] = _immPortId;}
    map['name'] = _immPortName;
    map['rate'] = _immPortRate;
    map['rate_during_adding'] = _immPortRateDuringAdding;
    map['coins_quantity'] = _immPortNumberOfCoins;
    map['total_value'] = _immPortTotalValue;
    return map;
  }

  ImmediatePortfolio.fromMap(Map<String, dynamic> map) {
    _immPortId = map['id'];
    _immPortName=map['name'] ;
    _immPortRate =  map['rate'];
    _immPortRateDuringAdding= map['rate_during_adding'] ;
    _immPortNumberOfCoins = map['coins_quantity'] ;
    _immPortTotalValue= map['total_value'];
  }
}
