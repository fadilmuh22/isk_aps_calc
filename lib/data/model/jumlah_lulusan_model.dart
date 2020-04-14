import 'package:isk_aps_calc/constants.dart';

class JumlahLulusanModel {
  String type, variable;
  List<String> title;
  List<dynamic> value;

  JumlahLulusanModel({
    this.type,
    this.variable,
    this.title,
    this.value = const [0, 0, 0],
  }) {
    if (this.type == Constants.lulusanTanggap) {
      this.title = [
        'Jumlah Koresponden TS-4',
        'Jumlah Koresponden TS-3',
        'Jumlah Koresponden TS-2'
      ];
    } else {
      this.title = [
        'Jumlah Lulusan TS-4',
        'Jumlah Lulusan TS-3',
        'Jumlah Lulusan TS-2'
      ];
    }
  }

  JumlahLulusanModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'title': title,
        'value': value,
      };
}
