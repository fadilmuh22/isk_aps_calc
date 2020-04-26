class MappingRankedModel {
  int educationStage;
  String indicatorCategory;
  String indicatorSubcategory;
  double indicatorValue;
  String currentAccreditation;
  String ranked;
  String ranked_target;

  MappingRankedModel({
    this.educationStage,
    this.indicatorCategory,
    this.indicatorSubcategory,
    this.indicatorValue,
    this.ranked,
    this.ranked_target,
    String currentAccreditation,
  });

  MappingRankedModel.fromJson(Map<String, dynamic> json) {
    ranked = json['ranked'];
    ranked_target = json['ranked_target'];
  }

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicator_subcategory': indicatorSubcategory,
      };
}
