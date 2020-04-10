import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel _newSimulation;
  var indicator;

  set newSimulation(NewSimulationModel newSimulation) {
    _newSimulation = newSimulation;
  }

  NewSimulationModel get newSimulation {
    return _newSimulation;
  }

  accreditate(indicator) {
    this.indicator = indicator;
    return this.indicator;
  }

  clear() {
    _newSimulation = null;
  }
}
