import 'package:isk_aps_calc/data/model/subcategory_model.dart';
import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';

class IndicatorDao {
  Future<List<MappingIndicatorModel>> mappingIndicator(
    int educationStage,
  ) async {
    var mapList = await AppDatabase().db.rawQuery('''
      SELECT *
      FROM mapping_stage_indicator
      JOIN indicator_category
        ON mapping_stage_indicator.indicator_category = indicator_category.indicator_category_id
      WHERE mapping_stage_indicator.education_stage = $educationStage
    ''');
    List<MappingIndicatorModel> mappingIndicator = mapList
        .map<MappingIndicatorModel>(
            (data) => MappingIndicatorModel.fromJson(data))
        .toList();
    for (var i = 0; i < mappingIndicator.length; i++) {
      var indicator = await this.select(
        mappingIndicator[i].indicatorCategory,
        mappingIndicator[i].indicatorSubcategory,
      );
      mappingIndicator[i].indicator = indicator;

      var subcategory = await this.subcategory(
        mappingIndicator[i].indicatorSubcategory,
      );
      mappingIndicator[i].subcategory = subcategory;
    }
    return mappingIndicator;
  }

  Future<List<IndicatorModel>> select(
    String indicatorCategory,
    String indicatorSubcategory,
  ) async {
    var mapList = await AppDatabase().db.rawQuery(
      '''
      SELECT * FROM indicator
      JOIN mapping_formula
        ON mapping_formula.indicator_category = indicator.indicator_category
          AND mapping_formula.indicator_subcategory = indicator.indicator_subcategory
      WHERE indicator.indicator_category = ? AND indicator.indicator_subcategory = ?
      GROUP BY indicator.indicator_name;
      ''',
      [
        indicatorCategory,
        indicatorSubcategory,
      ],
    );
    if (mapList.isNotEmpty) {
      return mapList
          .map<IndicatorModel>((result) => IndicatorModel.fromJson(result))
          .toList();
    }
    return null;
  }

  Future<List<SubcategoryModel>> subcategory(String id) async {
    var results = await AppDatabase().db.query(
          'indicator_subcategory',
          where: 'indicator_subcategory_id=?',
          whereArgs: [id],
          limit: 1,
        );
    if (results.isNotEmpty) {
      return results
          .map<SubcategoryModel>((result) => SubcategoryModel.fromJson(result))
          .toList();
    }
    return null;
  }
}
