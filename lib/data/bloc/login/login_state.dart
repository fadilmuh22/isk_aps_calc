import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final List propss;
  LoginState([this.propss]);

  @override
  List<Object> get props => ([ ...propss ?? [] ]);
}

class InitialLoginState extends LoginState {
}

class LoadingLoginState extends LoginState {
}


class SuccessLoginState extends LoginState {
  final String data;

  SuccessLoginState(this.data) : super([data]);
}

class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage) : super([errorMessage]);
}
