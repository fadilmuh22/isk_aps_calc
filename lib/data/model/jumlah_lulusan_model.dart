class JumlahLulusanModel {
  String type, variable;
  List<String> title;
  List<int> value;

  JumlahLulusanModel({
    this.type,
    this.variable,
    this.title = const [
      'Jumlah Lulusan TS-4',
      'Jumlah Lulusan TS-4',
      'Jumlah Lulusan TS-4'
    ],
    this.value,
  });

  JumlahLulusanModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['value'];
    value = json['type'];
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'title': title,
        'value': value,
      };
}
