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
      GROUP BY mapping_stage_indicator.indicator_category;
    ''');
    List<MappingIndicatorModel> mappingIndicator = mapList
        .map<MappingIndicatorModel>(
            (data) => MappingIndicatorModel.fromJson(data))
        .toList();
    for (var i = 0; i < mappingIndicator.length; i++) {
      var indicator = await this.select(mappingIndicator[i].indicatorCategory,
          mappingIndicator[i].indicatorSubcategory);
      mappingIndicator[i].indicator = indicator;
    }
    return mappingIndicator;
  }

  Future<List<IndicatorModel>> select(
    String indicatorCategory,
    String indicatorSubCategory,
  ) async {
    var mapList = await AppDatabase().db.query(
      'indicator',
      where: 'indicator_category=?',
      whereArgs: [indicatorCategory],
    );
    if (mapList.isNotEmpty) {
      return mapList
          .map<IndicatorModel>((user) => IndicatorModel.fromJson(user))
          .toList();
    }
    return null;
  }
}
