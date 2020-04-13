class MappingIndicatorModel {
  int educationStage;
  String educationStageName,
      indicatorCategory,
      indicatorCategoryName,
      indicatorSubcategory;
  List<dynamic> indicator;

  MappingIndicatorModel({
    this.educationStage,
    this.educationStageName,
    this.indicatorCategory,
    this.indicatorCategoryName,
    this.indicatorSubcategory,
    this.indicator,
  });

  MappingIndicatorModel.fromJson(Map<String, dynamic> json)
      : educationStage = json['education_stage'],
        indicatorCategory = json['indicator_category'],
        indicatorCategoryName = json['indicatory_category_name'],
        indicatorSubcategory = json['indicator_subcategory'],
        indicator = json['indicator'];

  Map<String, dynamic> toJson() => {
        'education_stage': educationStage,
        'indicator_category': indicatorCategory,
        'indicatory_category_name': indicatorCategoryName,
        'indicatory_subcategory': indicatorSubcategory,
        'indicator': indicator,
      };
}
