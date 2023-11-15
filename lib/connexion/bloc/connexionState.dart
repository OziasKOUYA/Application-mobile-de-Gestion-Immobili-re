part of 'connexionBloc.dart';
abstract class ConnexionState extends Equatable {
  const ConnexionState();
}

class ConnectionInitialState extends ConnexionState {
  @override
  List<Object> get props => [];
}

class ConnectionSuccessState extends ConnexionState {
  @override
  List<Object> get props => [];
}

class ConnectionFailureState extends ConnexionState {
  @override
  List<Object> get props => [];
}
