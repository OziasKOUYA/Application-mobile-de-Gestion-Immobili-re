part of 'authenticationBloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
const _AuthenticationStatusChanged(this.status);

final AuthenticationStatus status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {
  const AuthenticationLogoutRequested(this.context);
  final BuildContext context;
}

