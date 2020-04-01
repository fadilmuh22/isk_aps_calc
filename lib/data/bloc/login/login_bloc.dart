import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:isk_aps_calc/data/bloc/login/login_event.dart';
import 'package:isk_aps_calc/data/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  @override
  LoginState get initialState => InitialLoginState();

  // void onChangeUsername(String value) { 
  //   add(OnChangeUsernameEvent(value));

  // void onChangePassword(String value) { 
  //   add(OnChangePasswordEvent(value));
  // }

  void onSubmit(Map<String, String> data) {
    add(OnSubmitEvent(data));
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if ( event is OnSubmitEvent ) {
      yield LoadingLoginState();
      await Future.delayed(Duration(seconds: 1));
      yield SuccessLoginState('Login Berhasil');
    }
  }

}