import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_shopping/login/bloc/login_bloc.dart';

import 'login_form.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        create: (context) {
          return LoginBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context));
        },
        child: LoginForm(),
      ),
    );
  }
}