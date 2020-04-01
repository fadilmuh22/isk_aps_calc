import 'package:bloc/bloc.dart';

import 'package:isk_aps_calc/data/bloc/simulation/simulation_event.dart';
import 'package:isk_aps_calc/data/bloc/simulation/simulation_state.dart';

class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {

  @override
  SimulationState get initialState => InitialSimulationState();

  @override
  Stream<SimulationState> mapEventToState(SimulationEvent event) {
    return null;
  }
  
}