class MappingRankedModel {
  int educationStage;
  String indicatorCategory;
  String indicatorSubcategory;
  double indicatorValue;
  String currentAccreditation;
  String ranked;
  String rankedTarget;
  int rankedCurrentId;
  int rankedTargetId;

  MappingRankedModel({
    this.educationStage,
    this.indicatorCategory,
    this.indicatorSubcategory,
    this.indicatorValue,
    this.ranked,
    this.rankedTarget,
    this.currentAccreditation,
    this.rankedCurrentId,
    this.rankedTargetId,
  });

  MappingRankedModel.fromJson(Map<String, dynamic> json) {
    ranked = json['ranked'];
    rankedTarget = json['ranked_target'];
    rankedCurrentId = json['ranked_current_id'];
    rankedTargetId = json['ranked_target_id'];
  }

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicator_subcategory': indicatorSubcategory,
      };
}
