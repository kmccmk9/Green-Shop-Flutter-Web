import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository}) : _authenticationRepository = authenticationRepository, super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = event.username;
    LoginStatus status = (username.isNotEmpty && state.password.isNotEmpty) ? LoginStatus.valid : LoginStatus.invalid;
    emit(state.copyWith(username: username, status: status));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = event.password;
    LoginStatus status = (state.username.isNotEmpty && password.isNotEmpty) ? LoginStatus.valid : LoginStatus.invalid;
    emit(state.copyWith(password: password, status: status));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status == LoginStatus.valid) {
      emit(state.copyWith(status: LoginStatus.inProgress));
      try {
        await _authenticationRepository.login(username: state.username, password: state.password);
        emit(state.copyWith(status: LoginStatus.success));
      } catch (_) {
        emit(state.copyWith(status: LoginStatus.failure));
      }
    }
  }
}