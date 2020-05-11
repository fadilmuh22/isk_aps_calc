class MappingRankedConvertModel {
  String currentAccreditation;
  String inputAccreditation;
  String rankedConvert;

  MappingRankedConvertModel({
    this.currentAccreditation,
    this.inputAccreditation,
    this.rankedConvert,
  });

  MappingRankedConvertModel.fromJson(Map<String, dynamic> json)
      : rankedConvert = json['ranked_convert'];

  Map<String, dynamic> toJson() => {
        'accreditation_name': currentAccreditation,
        'input_accreditation': inputAccreditation,
        'ranked_convert': rankedConvert,
      };
}
