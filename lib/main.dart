import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_shopping/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_web_shopping/login/login.dart';
import 'package:flutter_web_shopping/products/bloc/product_bloc.dart';
import 'package:flutter_web_shopping/products/view/products_list.dart';
import 'package:http/http.dart' as http;
import 'package:url_strategy/url_strategy.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp(authenticationRepository: AuthenticationRepository(), userRepository: UserRepository()));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  const MyApp({Key? key, required this.authenticationRepository, required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository, userRepository: userRepository),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Green Shop!',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const MyHomePage(title: 'Green Shop! - Home Page'),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 80,
        actions: [
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                debugPrint(state.status.toString());
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    return Row(
                      children: [
                        Builder(builder: (context) {
                          final firstName = context.select((AuthenticationBloc bloc) => bloc.state.user.firstName);
                          final lastName = context.select((AuthenticationBloc bloc) => bloc.state.user.lastName);
                          return Text('Welcome back $firstName $lastName');
                        }),
                        Container(width: 20,),
                        ElevatedButton(
                            onPressed: () {
                              context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                            },
                            child: const Text('Logout')
                        )
                      ],
                    );
                  case AuthenticationStatus.unknown:
                  case AuthenticationStatus.unauthenticated:
                    return LoginWidget();
                  default:
                    return Container();
                }
              }
          )
        ],
      ),
      body: Center(
        child: BlocProvider(
          create: (_) => ProductBloc(httpClient: http.Client())..add(ProductFetched()),
          child: ProductsList(),
        )
      ),
    );
  }
}
