import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_immeuble/bloc/immeubleBloc.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_immeuble/immeubleService.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_publication/bloc/publicationBloc.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_publication/publicationService.dart';
import 'package:gestion_immobiliere/register/bloc/registerBloc.dart';
import 'package:gestion_immobiliere/register/registerService.dart';
import 'package:gestion_immobiliere/splash/view/splash_page.dart';
import 'authentification/authenticationService.dart';
import 'authentification/blocs/authenticationBloc.dart';
import 'authentification/userService.dart';
import 'connexion/bloc/connexionBloc.dart';
import 'home_client/view/home_page.dart';
import 'home_gerant/view/home_page.dart';
import 'login/view/login_page.dart';



MaterialColor myCustomColor = MaterialColor(0xFF1B283F, {
  50: Color(0xFF6D8AAF),
  100: Color(0xFF586E96),
  200: Color(0xFF435482),
  300: Color(0xFF2E406E),
  400: Color(0xFF192C5A),
  500: Color(0xFF142548),
  600: Color(0xFF0F1C36),
  700: Color(0xFF0A1224),
  800: Color(0xFF050812),
  900: Color(0xFF000000),
});


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationService _authenticationService;
  late final UserService _userService;
  late final RegisterService _registerService;
  late final ConnectionBloc _connectionBloc;
  late final ImmeubleService _immeubleService;
  late final PublicationService _publicationService;



  @override
  void initState() {
    super.initState();
    _authenticationService = AuthenticationService();
    _userService = UserService();
    _registerService = RegisterService();
    _connectionBloc=ConnectionBloc();
    _immeubleService=ImmeubleService();
    _publicationService=PublicationService();
  }

  @override
  void dispose() {
    _authenticationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationService,
        ),
        RepositoryProvider.value(
          value: _registerService,
        ),
        RepositoryProvider.value(
            value: _immeubleService),
        RepositoryProvider.value(
            value: _publicationService)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
              authenticationService: _authenticationService,
              userService: _userService,
            ),
          ),
          BlocProvider<ConnectionBloc>(
            create: (_) => ConnectionBloc(),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(
              registerService: context.read<RegisterService>(),
            ),
          ),
          BlocProvider<ImmeubleBloc>(
            create: (context) => ImmeubleBloc(
                immeubleService: context.read<ImmeubleService>(), connectionBloc:_connectionBloc, context: context

            ),
          ),
          BlocProvider<PublicationBloc>(
              create:(context)=>PublicationBloc(
                  publicationService:context.read<PublicationService>(), connectionBloc:_connectionBloc, context: context))
        ],
        child: const AppView(),

      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: myCustomColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: myCustomColor,
          accentColor: const Color(0xFF6D8AAF), // Set the secondary color
        ),
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                if (state.role == 'client') {
                  print(state.role);
                  GetClientEvent event = GetClientEvent(state.user.idUser);
                  BlocProvider.of<RegisterBloc>(context).add(event);
                  _navigator.pushAndRemoveUntil<void>(
                    HomeClient.route(),
                        (route) => false,
                  );
                } else if (state.role == 'gerant') {
                  print(state.role);
                  GetGerantEvent event = GetGerantEvent(state.user.idUser);
                  BlocProvider.of<RegisterBloc>(context).add(event);
                  _navigator.pushAndRemoveUntil<void>(
                    HomeGerant.route(),
                        (route) => false,
                  );
                }
                break;
              case AuthenticationStatus.unauthenticated:
                print('non authentifié');
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                      (route) => false,
                );
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}