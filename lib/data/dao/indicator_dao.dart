import 'dart:convert';

import 'package:isk_aps_calc/data/repository/app_database.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:sqflite/sqlite_api.dart';

class IndicatorDao {
  Future<List<MappingIndicatorModel>> mappingIndicator(
    int educationStage,
  ) async {
    Database db = await AppDatabase().db;
    var mapList = await db.rawQuery('''
      SELECT *
      FROM mapping_stage_indicator
      JOIN indicator_subcategory
        ON indicator_subcategory.indicator_subcategory_id = mapping_stage_indicator.indicator_subcategory
      JOIN mapping_formula
        ON mapping_formula.indicator_category = mapping_stage_indicator.indicator_category
          AND mapping_formula.indicator_subcategory = mapping_stage_indicator.indicator_subcategory
          AND mapping_formula.education_stage = ?
      JOIN indicator_category
        ON mapping_stage_indicator.indicator_category = indicator_category.indicator_category_id
      WHERE mapping_stage_indicator.education_stage = ?
      ORDER BY indicator_subcategory.seq;
    ''', [
      educationStage,
      educationStage,
    ]);
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
    }
    return mappingIndicator;
  }

  Future<List<IndicatorModel>> select(
    String indicatorCategory,
    String indicatorSubcategory,
  ) async {
    Database db = await AppDatabase().db;
    var mapList = await db.rawQuery(
      '''
      SELECT * FROM indicator
      WHERE indicator.indicator_category = ? AND indicator.indicator_subcategory = ?
      GROUP BY indicator.indicator_name
      ORDER BY indicator.seq;
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
}
