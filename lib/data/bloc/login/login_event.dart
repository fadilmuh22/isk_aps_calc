import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  final List propss;
  LoginEvent([this.propss]);

  @override
  List<Object> get props => ([ ...propss ?? [] ]);
}

class OnChangeUsernameEvent extends LoginEvent {
  final String username;

  OnChangeUsernameEvent(this.username) : super([username]);
}

class OnChangePasswordEvent extends LoginEvent {
  final String password;

  OnChangePasswordEvent(this.password) : super([password]);
}

class OnSubmitEvent extends LoginEvent {
  final Map<String, String> data;

  OnSubmitEvent(this.data) : super([data]);
}
