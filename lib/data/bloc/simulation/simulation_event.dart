import 'package:equatable/equatable.dart';

abstract class SimulationEvent extends Equatable {
  final List propss;
  SimulationEvent([this.propss]);

  @override
  List<Object> get props => ([ ...propss ?? [] ]);
}

class OnChangeUsernameEvent extends SimulationEvent {
  final String username;

  OnChangeUsernameEvent(this.username) : super([username]);
}

class OnChangePasswordEvent extends SimulationEvent {
  final String password;

  OnChangePasswordEvent(this.password) : super([password]);
}

class OnSubmitEvent extends SimulationEvent {
  final Map<String, String> data;

  OnSubmitEvent(this.data) : super([data]);
}