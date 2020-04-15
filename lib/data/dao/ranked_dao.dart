import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';

class RankedDao {
  Future<MappingRankedModel> mappingRanked(
    MappingRankedModel mappingRankedModel,
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
    MappingRankedModel mappingRanked = MappingRankedModel.fromJson(result[0]);

    return mappingRanked;
  }
}
