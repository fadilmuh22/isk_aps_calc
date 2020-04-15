import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';

class RankedDao {
  Future<MappingRankedModel> mappingRanked(
    int educationStage,
    String indicatorCategory,
    String indicatorSubcategory,
    double indicatorValue,
  ) async {
    var result = await AppDatabase().db.rawQuery('''
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
    MappingRankedModel mappingRanked = MappingRankedModel.fromJson(result[0]);

    return mappingRanked;
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
