import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/dao/history_dao.dart';
import 'package:isk_aps_calc/data/dao/indicator_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_convert_dao.dart';

import 'package:isk_aps_calc/data/formula.dart';
import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:isk_aps_calc/data/repository/app_storage.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel newSimulation;
  List<MappingIndicatorModel> mapIndicator;

  MappingRankedConvertModel resultConvert;
  String inputRank;

  Function goToPage;

  Future mappingIndicator() async {
    mapIndicator =
        await IndicatorDao().mappingIndicator(newSimulation.educationStage);
    notifyListeners();
  }

  Future accreditate(
    Map<String, dynamic> map,
    List<MappingIndicatorModel> lmap,
  ) async {
    List<MappingRankedModel> results = [];

    var mapVariable = map;
    mapVariable.forEach((k, v) {
      if (v is int) {
        mapVariable[k] = v.toDouble();
      } else if (v is String) {
        if (v.isEmpty) {
          mapVariable[k] = 0.0;
        } else {
          mapVariable[k] = double.parse(v);
        }
      } else if (v is double) {
        mapVariable[k] = v;
      } else {
        mapVariable[k] = 0.0;
      }
    });

    mapIndicator = Formula().accreditate(mapVariable, lmap);

    for (int i = 0; i < mapIndicator.length; i++) {
      MappingRankedModel mappingRankedModel = MappingRankedModel(
        educationStage: mapIndicator[i].educationStage,
        indicatorCategory: mapIndicator[i].indicatorCategory,
        indicatorSubcategory: mapIndicator[i].indicatorSubcategory,
        indicatorValue: mapIndicator[i].indicatorValue.isNaN ||
                mapIndicator[i].indicatorValue.isInfinite
            ? 0.0
            : mapIndicator[i].indicatorValue,
      );

      var rank = await RankedDao().mappingRanked(mappingRankedModel);
      results.add(rank);
    }

    int rank0 = results
        .where((mapRanked) => mapRanked.ranked.toLowerCase().contains('belum'))
        .toList()
        .length;
    int rank1 = results
        .where((mapRanked) => mapRanked.ranked == Constants.baik)
        .toList()
        .length;
    int rank2 = results
        .where((mapRanked) => mapRanked.ranked == Constants.baikSekali)
        .toList()
        .length;
    int rank3 = results
        .where((mapRanked) => mapRanked.ranked == Constants.unggul)
        .toList()
        .length;

    if (rank3 > 0) {
      inputRank = Constants.unggul;
    }
    if (rank2 > 0) {
      inputRank = Constants.baikSekali;
    }
    if (rank1 > 0) {
      inputRank = Constants.baik;
    }
    if (rank0 > 0) {
      inputRank = 'BELUM MEMENUHI SYARAT AKREDITASI [2]';
    }

    MappingRankedConvertModel mappingRankedConvertModel =
        MappingRankedConvertModel(
      currentAccreditation:
          newSimulation.currentAccreditation ?? 'Belum memenuhi syarat ',
      inputAccreditation: inputRank ?? 'BELUM MEMENUHI SYARAT AKREDITASI [2]',
    );

    resultConvert = await RankedConvertDao()
        .mappingRankedConvert(mappingRankedConvertModel);

    createHistory(mapVariable, lmap).whenComplete(() {});

    notifyListeners();
  }

  Future createHistory(map, lmap) async {
    UserModel user =
        UserModel.fromJson(jsonDecode(await AppStorage().read(key: 'user')));

    Map<String, dynamic> mapVariable = map;
    mapVariable.forEach((k, v) {
      if (mapVariable[k].isNaN || mapVariable[k].isInfinite) {
        mapVariable[k] = 0.0;
      }
    });

    HistoryModel newHistory = HistoryModel(
      institute: user.institute,
      studyProgram: newSimulation.studyProgramName,
      educationStage: newSimulation.educationStage,
      educationStageName: newSimulation.educationStageName,
      indicatorDetail: jsonEncode(lmap),
      variables: map,
      result: resultConvert.rankedConvert,
      resultDetail: jsonEncode(mapIndicator),
      userId: user.id.toString(),
      updateDateTime: DateTime.now().toString(),
    );

    await HistoryDao().insert(newHistory);
  }

  Future<List<HistoryModel>> getHistories() async {
    UserModel user =
        UserModel.fromJson(jsonDecode(await AppStorage().read(key: 'user')));
    return await HistoryDao().select(user.id);
  }

  Future<int> deleteHistory(int id) async {
    return await HistoryDao().delete(id);
  }

  clear() {
    newSimulation = null;
  }
}
