class MappingIndicatorModel {
  int educationStage;
  double indicatorValue;
  String educationStageName,
      indicatorCategory,
      indicatorCategoryName,
      indicatorSubcategory,
      indicatorSubcategoryName,
      formula,
      ranked,
      rankedTarget,
      description;
  List<dynamic> indicator;

  MappingIndicatorModel({
    this.educationStage,
    this.educationStageName,
    this.indicatorCategory,
    this.indicatorCategoryName,
    this.indicatorSubcategory,
    this.indicatorSubcategoryName,
    this.indicator,
    this.formula,
    this.ranked,
    this.rankedTarget,
    this.description,
  });

  MappingIndicatorModel.fromJson(Map<String, dynamic> json) {
    educationStage = json['education_stage'];
    indicatorCategory = json['indicator_category'];
    indicatorCategoryName = json['indicator_category_name'];
    indicatorSubcategory = json['indicator_subcategory'];
    indicatorSubcategoryName = json['indicator_subcategory_name'];
    indicatorValue = json['indicator_value'];
    indicator = json['indicator'];
    formula = json['formula'];
    ranked = json['ranked'];
    rankedTarget = json['ranked_target'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicator_category_name': indicatorCategoryName,
        'indicator_subcategory': indicatorSubcategory,
        'indicator_subcategory_name': indicatorSubcategoryName,
        'indicator_value': indicatorValue.isNaN ? 0.0 : indicatorValue,
        'indicator': indicator,
        'formula': formula,
        'ranked': ranked,
        'ranked_target': rankedTarget,
        'description': description,
      };
}
