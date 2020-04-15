class SubcategoryModel {
  String id, category, name;

  SubcategoryModel({
    this.id,
    this.category,
    this.name,
  });

  SubcategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['indicator_subcategory_id'];
    category = json['indicator_category'];
    name = json['indicator_subcategory_name'];
  }
}
