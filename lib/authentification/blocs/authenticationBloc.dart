import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_immobiliere/register/models/Utilisateur.dart';
import '../authenticationService.dart';
import '../models/User.dart';
import '../userService.dart';

part 'authenticationEvent.dart';
part 'authenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationService authenticationService,
    required UserService userService,
  })  : _authenticationService = authenticationService,
        _userService = userService,

        super( AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationService.status.listen(
          (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationService _authenticationService;
  final UserService _userService;
  late StreamSubscription<AuthenticationStatus>
  _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
      _AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit,
      ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null && user.role != null  // Check if user.role is not null
              ? AuthenticationState.authenticated(user, user.role)
              : const AuthenticationState.unauthenticated(),
        );

      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationService.logOut(event.context);
  }

  Future<User?> _tryGetUser() async {
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    try {
      User? user = await _userService.getUser(token!);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<Utilisateur?> _tryGetUtilisateur() async {
    final storage = new FlutterSecureStorage();
    String? username = await storage.read(key: 'username');
    try {
      Utilisateur? artisan = await _userService.getUtilisateurByUsername(username!);
      return artisan;
    } catch (e) {
      return null;
    }
  }


}
