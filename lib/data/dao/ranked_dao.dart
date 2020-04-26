import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';
import 'package:sqflite/sqflite.dart';

class RankedDao {
  Future<MappingRankedModel> mappingRanked(
    MappingRankedModel mappingRankedModel,
  ) async {
    Database db = await AppDatabase().db;
    var result = await db.rawQuery('''
      select
      case
        when ? >= rank3 then 'UNGGUL'
        when ? >= rank2 and ? < rank3 then 'BAIK SEKALI'
        when ? >= rank1 and ? < rank3 and ? < rank2 then 'BAIK'
        else 'BELUM MEMENUHI SYARAT AKREDITASI [0]'
      end "ranked",
      (
        SELECT z.accreditation_name
        FROM accreditation z
        WHERE z.accreditation_id = (
                                       SELECT x.accreditation_id
                                       FROM accreditation x
                                       WHERE x.accreditation_name = ?
                                   ) + 1
        ) "ranked_target"
      from accreditation_rank
      where education_stage = ?
      and indicator_category = ?
      and indicator_subcategory = ?
    ''', [
      mappingRankedModel.currentAccreditation,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.educationStage,
      mappingRankedModel.indicatorCategory,
      mappingRankedModel.indicatorSubcategory,
    ]);
    MappingRankedModel mappingRanked;

    if (result != null && result != [] && result.isNotEmpty) {
      mappingRanked = MappingRankedModel.fromJson(result[0]);
    }

    return mappingRanked ?? MappingRankedModel(ranked: 'TIDAK ADA MAPPING');
  }
}
