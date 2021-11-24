part of 'login_bloc.dart';

enum LoginStatus { valid, invalid, inProgress, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String username;
  final String password;

  const LoginState({this.status = LoginStatus.invalid, this.username = '', this.password = ''});

  LoginState copyWith({LoginStatus? status, String? username, String? password}) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  bool isValidated() {
    return (username.isNotEmpty && password.isNotEmpty);
  }

  @override
  List<Object> get props => [status, username, password];
}