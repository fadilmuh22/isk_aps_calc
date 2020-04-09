class IndicatorModel {
  int id, type;
  String category, subcategory, name, variable;
  dynamic defaultValue, value;

  IndicatorModel({
    this.id,
    this.category,
    this.subcategory,
    this.name = 'fadil',
    this.variable,
    this.type,
    this.defaultValue,
  });

  IndicatorModel.fromMap(Map<String, dynamic> map) {
    id = map['indicator_id'];
    category = map['indicator_category'];
    subcategory = map['indicator_subcategory'];
    name = map['indicator_name'];
    variable = map['indicator_variable'];
    type = map['indicator_type'];
    defaultValue = map['default_value'];
  }

  Map<String, dynamic> toMap(IndicatorModel indicator) => {
        'indicator_id': id,
        'indicator_category': category,
        'indicator_subcategory': subcategory,
        'indicator_name': name,
        'indicator_variable': variable,
        'indicator_type': type,
        'indicator_default_value': defaultValue,
      };
}
