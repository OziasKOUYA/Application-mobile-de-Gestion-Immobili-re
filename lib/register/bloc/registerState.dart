part of 'registerBloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class UpdateSuccess extends RegisterState{}

class UpdateLoading extends RegisterState{}

class GetGerantSuccess extends RegisterState{
  final Utilisateur utilisateur;
  const GetGerantSuccess({required this.utilisateur});
  @override
  List<Object> get props => [utilisateur];
}

class GetClientSuccess extends RegisterState{
  final Utilisateur utilisateur;
  const GetClientSuccess({required this.utilisateur});
  @override
  List<Object> get props => [utilisateur];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object> get props => [error];
}

class GetUtilisateurFailure extends RegisterState {
  final String error;

  const GetUtilisateurFailure(this.error);

  @override
  List<Object> get props => [error];
}