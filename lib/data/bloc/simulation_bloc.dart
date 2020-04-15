import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/dao/indicator_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_dao.dart';
import 'package:isk_aps_calc/data/dao/ranked_convert_dao.dart';

import 'package:isk_aps_calc/data/formula.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';
import 'package:isk_aps_calc/data/model/mapping_ranked_convert_model.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel newSimulation;
  List<MappingIndicatorModel> mapIndicator;
  MappingRankedConvertModel resultConvert;
  String inputRank;

  Future mappingIndicator() async {
    mapIndicator =
        await IndicatorDao().mappingIndicator(newSimulation.educationStage);
    notifyListeners();
  }

  Future accreditate(
    Map<String, dynamic> map,
    List<MappingIndicatorModel> lmap,
  ) async {
    List<MappingRankedModel> results;

    var resultFormula = Formula().accreditate(map, lmap);

    resultFormula.map((mapIndicator) {
      mapIndicator.indicator.map((indicator) {
        MappingRankedModel mappingRankedModel = MappingRankedModel(
          educationStage: mapIndicator.educationStage,
          indicatorCategory: indicator.indicatorCategory,
          indicatorSubcategory: indicator.indicatorSubcategory,
          indicatorValue: indicator.value,
        );
        MappingRankedModel result;
        RankedDao()
            .mappingRanked(mappingRankedModel)
            .then((value) => result = value);
        results.add(result);
      });
    });

    print('ini results $results');

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

    MappingRankedConvertModel mappingRankedConvertModel =
        MappingRankedConvertModel(
      currentAccreditation: newSimulation.currentAccreditation,
      inputAccreditation: inputRank,
    );

    RankedConvertDao()
        .mappingRankedConvert(mappingRankedConvertModel)
        .then((value) {
      print('ini rank ${value.rankedConvert}');
      return resultConvert = value;
    });

    mapIndicator =
        await IndicatorDao().mappingIndicator(newSimulation.educationStage);

    notifyListeners();
  }

  clear() {
    newSimulation = null;
  }
}
