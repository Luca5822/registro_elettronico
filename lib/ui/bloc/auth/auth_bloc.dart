import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String _profile;
  LoginRepository _loginRepository;

  AuthBloc(this._loginRepository);

  @override
  AuthState get initialState => Init();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignIn) {
      yield SignInLoading();
      final res = await _loginRepository.signIn(
          username: event.username, password: event.password);
      switch (res.statusCode) {
        case 200:
          yield SignInSuccess(res.body['firstName']);
          break;
        case 422:
          yield SignInError("Wrong user credentials");
          break;
        default:
          yield SignInError(
              "A strange error has accoured! Status code ${res.statusCode}");
          break;
      }
    }
  }
}
