// ignore_for_file: file_names

class ImmCryptListCon {
  final int? id;
  final String? fullName;
  final String? name;
  final String? sysmbol;

  ImmCryptListCon(
      {this.id,
        this.name,
        this.fullName,
        this.sysmbol,
      }
      );


  factory ImmCryptListCon.fromJson(Map<String, dynamic> json) {
    return ImmCryptListCon(
      id: json["id"],
      name: json["name"],
      fullName: json["fullName"],
      sysmbol: json["sysmbol"],
    );
  }
}
