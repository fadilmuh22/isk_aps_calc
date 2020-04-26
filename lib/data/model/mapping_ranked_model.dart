class MappingRankedModel {
  int educationStage;
  String indicatorCategory;
  String indicatorSubcategory;
  double indicatorValue;
  String currentAccreditation;
  String ranked;
  String rankedTarget;

  MappingRankedModel({
    this.educationStage,
    this.indicatorCategory,
    this.indicatorSubcategory,
    this.indicatorValue,
    this.ranked,
    this.rankedTarget,
    this.currentAccreditation,
  });

  MappingRankedModel.fromJson(Map<String, dynamic> json) {
    ranked = json['ranked'];
    rankedTarget = json['ranked_target'];
  }

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicator_subcategory': indicatorSubcategory,
      };
}
