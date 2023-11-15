part of 'connexionBloc.dart';
abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();
}

class CheckConnectionEvent extends ConnectionEvent {
  @override
  List<Object> get props => [];
}