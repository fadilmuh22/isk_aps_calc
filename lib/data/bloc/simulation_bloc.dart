import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/data/dao/indicator_dao.dart';

import 'package:isk_aps_calc/data/formula.dart';
import 'package:isk_aps_calc/data/model/mapping_indicator_model.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel newSimulation;
  List<MappingIndicatorModel> mapIndicator;

  Future mappingIndicator() async {
    mapIndicator =
        await IndicatorDao().mappingIndicator(newSimulation.educationStage);
    notifyListeners();
  }

  void accreditate(
    Map<String, dynamic> map,
    List<MappingIndicatorModel> lmap,
  ) {
    var resultFormula = Formula().accreditate(map, lmap);
    // resultFormula.indicator.map((indicator) {
    //   indicator.
    // });
    
    notifyListeners();
  }

  clear() {
    newSimulation = null;
  }
}
