import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_shopping/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previousState, currentState) => currentState.status != previousState.status,
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('Authentication Failure')));
          }
        },
      child: Row(
        children: [
          SizedBox(width: 100, child: _UsernameInputField(),),
          Container(width: 20),
          SizedBox(width: 100, child: _PasswordInputField(),),
          Container(width: 20,),
          _LoginButton(),
        ],
      ),
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
        builder: (context, state) {
          return TextField(
            onChanged: (username) => context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
              hintText: 'Username',
              errorText: state.username.isEmpty ? 'Invalid username' : null,
            ),
          );
        }
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          decoration: InputDecoration(
            hintText: 'Password',
            errorText: state.password.isEmpty ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.inProgress ? const CircularProgressIndicator()
            : ElevatedButton(
            onPressed: state.username.isNotEmpty && state.password.isNotEmpty ? () { context.read<LoginBloc>().add(const LoginSubmitted()); } : null,
            child: const Text('Login'),
        );
      },
    );
  }
}