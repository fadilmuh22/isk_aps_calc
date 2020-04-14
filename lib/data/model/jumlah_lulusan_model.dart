class JumlahLulusanModel {
  String type, variable;
  List<String> title;
  List<dynamic> value;

  JumlahLulusanModel({
    this.type,
    this.variable,
    this.title = const [
      'Jumlah Lulusan TS-4',
      'Jumlah Lulusan TS-3',
      'Jumlah Lulusan TS-2'
    ],
    this.value = const [0, 0, 0],
  });

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
