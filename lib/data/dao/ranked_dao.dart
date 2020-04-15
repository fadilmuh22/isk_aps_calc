import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';

class RankedDao {
  Future<List<MappingIndicatorModel>> mappingIndicator(
    int educationStage,
    String indicatorCategory,
    String indicatorSubcategory,
    double indicatorValue,
  ) async {
    var mapList = await AppDatabase().db.rawQuery('''
      select
      case
        when ? >= rank3 then 'UNGGUL'
        when ? >= rank2 and ? < rank3 then 'BAIK SEKALI'
        when ? >= rank1 and ? < rank3 and ? < rank2 then 'BAIK'
        else 'BELUM MEMENUHI SYARAT AKREDITASI'
      end "ranked"
      from accreditation_rank
      where education_stage = ?
      and indicator_category = ?
      and indicator_subcategory = ? ;
    ''', [
      indicatorValue,
      indicatorValue,
      indicatorValue,
      indicatorValue,
      indicatorValue,
      indicatorValue,
      educationStage,
      indicatorCategory,
      indicatorSubcategory,
    ]);
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
    String indicatorSubcategory,
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
