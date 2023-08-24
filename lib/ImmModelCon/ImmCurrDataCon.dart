// ignore_for_file: file_names

class ImmCurrDataCon {
  final int? id;
  final String? name;
  // All dogs start out at 10, because they're good dogs.

  ImmCurrDataCon(
      {this.id,
        this.name,
      });

  factory ImmCurrDataCon.fromJson(Map<String, dynamic> json) {
    return ImmCurrDataCon(
      id: json["id"],
      name: json["name"],
    );
  }
}
