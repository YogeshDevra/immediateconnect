// ignore_for_file: prefer_collection_literals, unnecessary_this, file_names

class ImmFavDataCon {
  int? _id;
  String? _name;
  String? _symbol;
  double? _rateDuringAdding;
  String? _diffRate;

  ImmFavDataCon(
      this._id,
      this._name,
      this._symbol,
      this._rateDuringAdding,
      this._diffRate,
      );

  int get id => _id!;

  String get name => _name!;
  String get symbol => _symbol!;
  double get rateDuringAdding => _rateDuringAdding!;
  String get diffRate => _diffRate!;

  ImmFavDataCon.map(dynamic obj) {
    this._id = obj['_id'];
    this._name = obj['name'];
    this._symbol = obj['symbol'];
    this._rateDuringAdding = obj['rate'];
    this._diffRate = obj['diffRate'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['symbol'] = _symbol;
    map['rate'] = _rateDuringAdding;
    map['diffRate'] = _diffRate;

    return map;
  }

  ImmFavDataCon.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._symbol = map['symbol'];
    this._rateDuringAdding = map['rate'];
    this._diffRate = map['diffRate'];
  }
// All dogs start out at 10, because they're good dogs.
}
