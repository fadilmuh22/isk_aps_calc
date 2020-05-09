import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/formula.dart';
import 'package:isk_aps_calc/data/model/indicator_model.dart';
import 'package:isk_aps_calc/data/repository/app_storage.dart';

import 'package:isk_aps_calc/data/dao/history_dao.dart';
import 'package:isk_aps_calc/data/dao/indicator_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_convert_dao.dart';

import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel newSimulation;
  Map<String, dynamic> mapVariable;
  List<MappingIndicatorModel> mapIndicator;

  MappingRankedConvertModel resultConvert;
  String inputRank;

  Function goToPage;
  int historyId;

  Future mappingIndicator() async {
    mapIndicator =
        await IndicatorDao().mappingIndicator(newSimulation.educationStage);
    notifyListeners();
  }

  Future accreditate(
    Map<String, dynamic> mapVariable,
    List<MappingIndicatorModel> lmap,
  ) async {
    List<MappingRankedModel> results = [];

    mapIndicator = Formula().accreditate(mapVariable, lmap);

    for (int i = 0; i < mapIndicator.length; i++) {
      MappingRankedModel mappingRankedModel = MappingRankedModel(
        currentAccreditation: newSimulation.currentAccreditation,
        educationStage: mapIndicator[i].educationStage,
        indicatorCategory: mapIndicator[i].indicatorCategory,
        indicatorSubcategory: mapIndicator[i].indicatorSubcategory,
        indicatorValue: mapIndicator[i].indicatorValue.isNaN ||
                mapIndicator[i].indicatorValue.isInfinite
            ? 0.0
            : mapIndicator[i].indicatorValue,
      );

      var rank = await RankedDao().mappingRanked(mappingRankedModel);
      if (rank.ranked == Constants.tidakAdaMapping) {
        continue;
      }
      mapIndicator[i].ranked = rank.ranked;
      mapIndicator[i].rankedTarget = rank.rankedTarget;
      mapIndicator[i].rankedCurrentId = rank.rankedCurrentId;
      mapIndicator[i].rankedTargetId = rank.rankedTargetId;
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

    createHistory(mapVariable, lmap).then((data) async {
      if (historyId != null) {
        updateHistory(data);
      } else {
        storeHistory(data);
      }
    });

    notifyListeners();
  }

  Future<HistoryModel> createHistory(map, lmap) async {
    UserModel user =
        UserModel.fromJson(jsonDecode(await AppStorage().read(key: 'user')));

    Map<String, dynamic> mapVariable = map;
    mapVariable.forEach((k, v) {
      if (mapVariable[k].isNaN || mapVariable[k].isInfinite) {
        mapVariable[k] = 0.0;
      }
    });

    HistoryModel history = HistoryModel(
      id: historyId,
      institute: user.institute ?? 'User\'s Institute',
      studyProgram: newSimulation.studyProgramName,
      educationStage: newSimulation.educationStage,
      educationStageName: newSimulation.educationStageName,
      currentAccreditation: newSimulation.currentAccreditation,
      academicYear: newSimulation.academicYear,
      indicatorDetail: jsonEncode(lmap),
      variables: map,
      result: resultConvert.rankedConvert,
      resultDetail: jsonEncode(mapIndicator),
      userId: user.id.toString(),
      updateDateTime: DateTime.now().toString(),
    );

    return history;
  }

  void bindDataHistory(HistoryModel history) {
    this.clear();

    this.historyId = history.id;
    NewSimulationModel historySimulation = NewSimulationModel(
      educationStage: history.educationStage,
      educationStageName: history.educationStageName,
      studyProgramName: history.studyProgram,
      currentAccreditation: history.currentAccreditation,
      academicYear: history.academicYear,
    );
    this.newSimulation = historySimulation;

    // ? Map Variables For User's Inputed Value
    Map<String, dynamic> mapVariable = history.variables;

    this.mapVariable = mapVariable;

    // ? Map Indicator Binding
    List<MappingIndicatorModel> mapIndicator = List();
    history.resultDetail.forEach((data) {
      var mapInd = MappingIndicatorModel.fromJson(data);
      mapInd.indicator =
          mapInd.indicator.map((ind) => IndicatorModel.fromJson(ind)).toList();
      mapIndicator.add(mapInd);
    });
    this.mapIndicator = mapIndicator;

    this.resultConvert =
        MappingRankedConvertModel(rankedConvert: history.result);
  }

  Future<int> storeHistory(HistoryModel history) async {
    return await HistoryDao().insert(history);
  }

  Future<List<HistoryModel>> getHistories() async {
    UserModel user =
        UserModel.fromJson(jsonDecode(await AppStorage().read(key: 'user')));
    return await HistoryDao().select(user.id);
  }

  Future<int> updateHistory(HistoryModel history) async {
    return await HistoryDao().update(history);
  }

  Future<int> deleteHistory(int id) async {
    return await HistoryDao().delete(id);
  }

  clear() {
    newSimulation = null;
    mapVariable = null;
    resultConvert = null;
    inputRank = null;
    historyId = null;
  }
}
