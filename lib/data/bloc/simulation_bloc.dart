import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/data/model/kurikulum_model.dart';
import 'package:isk_aps_calc/data/model/simulation_model.dart';

class SimulationBloc extends ChangeNotifier {
  
  SimulationModel _simulation;
  KurikulumModel _kurikulum;

  void set simulation(SimulationModel simulation) {
    _simulation = simulation;
  }

  SimulationModel get simulation {
    return _simulation;

  }

  void set kurikulum(KurikulumModel kurikulum) {
    _kurikulum = kurikulum;
  }

  KurikulumModel get kurikulum {
    return _kurikulum;
  }

  clear() {
    _simulation = null;
    _kurikulum = null;
  }

}