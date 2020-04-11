class MappingIndicatorModel {
  int educationStage;
  String indicatorCategory, indicatorCategoryName, indicatorSubcategory;
  List<dynamic> indicator;

  MappingIndicatorModel({
    this.educationStage,
    this.indicatorCategory,
    this.indicatorCategoryName,
    this.indicatorSubcategory,
    this.indicator,
  });

  MappingIndicatorModel.fromJson(Map<String, dynamic> json)
      : educationStage = json['education_stage'],
        indicatorCategory = json['indicator_category'],
        indicatorCategoryName = json['indicator_category_name'],
        indicatorSubcategory = json['indicator_subcategory'],
        indicator = json['indicator'];

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicator_category_name': indicatorCategoryName,
        'indicator_category': indicatorSubcategory,
        'indicator': indicator,
      };
}
