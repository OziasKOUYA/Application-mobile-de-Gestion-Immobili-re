part of 'registerBloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterClientEvent extends RegisterEvent {
  final Utilisateur utilisateur;


  RegisterClientEvent(this.utilisateur);

  @override
  List<Object?> get props => [utilisateur];
}

class RegisterGerantEvent extends RegisterEvent {
  final Utilisateur utilisateur;

  RegisterGerantEvent(this.utilisateur);

  @override
  List<Object?> get props => [utilisateur];
}


class GetClientEvent extends RegisterEvent{
  final int id;
  const GetClientEvent(this.id);
  @override
  List<Object> get props => [];
}

class GetGerantEvent extends RegisterEvent{
  final int id;
  const GetGerantEvent(this.id);
  @override
  List<Object> get props => [];
}

