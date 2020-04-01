import 'package:equatable/equatable.dart';

abstract class SimulationState extends Equatable {
  final List propss;
  SimulationState([this.propss]);

  @override
  List<Object> get props => ([ ...propss ?? [] ]);
}

class InitialSimulationState extends SimulationState {
}

class LoadingSimulationState extends SimulationState {
}

class NewlySimulationState extends SimulationState {
  final Map<String, String> prodi;

  NewlySimulationState(this.prodi) : super([prodi]);
}


class SuccessSimulationState extends SimulationState {
  final String data;

  SuccessSimulationState(this.data) : super([data]);
}

class ErrorSimulationState extends SimulationState {
  final String errorMessage;

  ErrorSimulationState(this.errorMessage) : super([errorMessage]);
}
