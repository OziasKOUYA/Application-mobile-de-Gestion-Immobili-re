part of 'authenticationBloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
    this.role = '',  // Add this line
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user, String role)  // Update this line
      : this._(status: AuthenticationStatus.authenticated, user: user, role: role);  // Update this line

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final User user;
  final String? role;  // Add this line

  @override
  List<Object> get props => [status, user, role??''];  // Update this line
}
