class MappingRankedModel {
  int educationStage;
  String indicatorCategory;
  String indicatorSubcategory;
  double indicatorValue;
  String ranked;

  MappingRankedModel({
    this.educationStage,
    this.indicatorCategory,
    this.indicatorSubcategory,
    this.indicatorValue,
    this.ranked,
  });

  MappingRankedModel.fromJson(Map<String, dynamic> json)
      : ranked = json['ranked'];

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicatory_subcategory': indicatorSubcategory,
      };
}
