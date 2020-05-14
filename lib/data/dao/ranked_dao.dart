import 'package:isk_aps_calc/constants.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';

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
        ) "ranked_target",
    (
        SELECT z.accreditation_id
        FROM accreditation z
        WHERE z.accreditation_id = (
                                       SELECT x.accreditation_id
                                       FROM accreditation x
                                       WHERE x.accreditation_name = ?
                                   ) + 1
    ) "ranked_current_id",
    case
        when ? >= rank3 then 6
        when ? >= rank2 and ? < rank3 then 4
        when ? >= rank1 and ? < rank3 and ? < rank2 then 2
        else 0
    end "ranked_target_id"
    from accreditation_rank
    where education_stage = ?
    and indicator_category = ?
    and indicator_subcategory = ?
    ''', [
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.indicatorValue,
      mappingRankedModel.currentAccreditation,
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

    return mappingRanked ??
        MappingRankedModel(ranked: Constants.tidakAdaMapping);
  }
}
