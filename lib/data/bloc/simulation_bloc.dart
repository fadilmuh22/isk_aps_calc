import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/data/model/new_simulation_model.dart';

class SimulationBloc extends ChangeNotifier {
  NewSimulationModel _newSimulation;

  set newSimulation(NewSimulationModel newSimulation) {
    _newSimulation = newSimulation;
  }

  NewSimulationModel get newSimulation {
    return _newSimulation;
  }

  clear() {
    _newSimulation = null;
  }
}
