class IndicatorModel {
  int id, type;
  String category, subcategory, subcategoryName, name, variable;
  dynamic defaultValue;

  IndicatorModel({
    this.id,
    this.category,
    this.subcategory,
    this.name,
    this.variable,
    this.type,
    this.defaultValue,
  });

  IndicatorModel.fromJson(Map<String, dynamic> json) {
    id = json['indicator_id'];
    category = json['indicator_category'];
    subcategory = json['indicator_subcategory'];
    name = json['indicator_name'];
    variable = json['indicator_variable'];
    type = json['indicator_type'];
    defaultValue = json['default_value'];
  }

  Map<String, dynamic> toJson() => {
        'indicator_id': id,
        'indicator_category': category,
        'indicator_subcategory': subcategory,
        'indicator_name': name,
        'indicator_variable': variable,
        'indicator_type': type,
        'default_value': defaultValue,
      };
}
