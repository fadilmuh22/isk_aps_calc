import 'package:sqflite/sqflite.dart';

import 'package:isk_aps_calc/data/repository/app_database.dart';

import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';

class RankedConvertDao {
  Future<MappingRankedConvertModel> mappingRankedConvert(
    MappingRankedConvertModel mappingRankedConvertModel,
  ) async {
    Database db = await AppDatabase().db;
    var result = await db.rawQuery('''
      SELECT count(accreditation_id)
            ,accreditation_id
            ,accreditation_name AS 'accreditation_achieved'
            ,CASE 
              WHEN accreditation_id >= (
                  SELECT x.accreditation_id
                  FROM accreditation x
                  WHERE x.accreditation_name = ?
                  )
                THEN 'TERAKREDITASI ' || (
                    SELECT z.accreditation_name
                    FROM accreditation z
                    WHERE z.accreditation_id = (
                        SELECT x.accreditation_id
                        FROM accreditation x
                        WHERE x.accreditation_name = ?
                        ) + 1
                    )
              ELSE 'BELUM MEMENUHI SYARAT ' || (
                  SELECT z.accreditation_name
                  FROM accreditation z
                  WHERE z.accreditation_id = (
                      SELECT x.accreditation_id
                      FROM accreditation x
                      WHERE x.accreditation_name = ?
                      ) + 1
                  )
              END 'ranked_convert'
          FROM accreditation
          WHERE accreditation_id = (
              SELECT x.accreditation_id
              FROM accreditation x
              WHERE x.accreditation_name = ?
              );
    ''', [
      mappingRankedConvertModel.currentAccreditation,
      mappingRankedConvertModel.currentAccreditation,
      mappingRankedConvertModel.currentAccreditation,
      mappingRankedConvertModel.inputAccreditation,
    ]);
    MappingRankedConvertModel mappingRanked =
        MappingRankedConvertModel.fromJson(result[0]);

    return mappingRanked;
  }
}
