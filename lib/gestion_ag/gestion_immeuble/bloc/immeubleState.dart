part of 'immeubleBloc.dart';

abstract class ImmeubleState extends Equatable {
  const ImmeubleState();
}

class ImmeubleInitial extends ImmeubleState {
  @override
  List<Object> get props => [];
}

class ImmeubleLoadInProgress extends ImmeubleState {
  @override
  List<Object> get props => [];
}

class ImmeubleLoadSuccess extends ImmeubleState {
  final List<Immeuble> immeubles;

  const ImmeubleLoadSuccess([this.immeubles = const []]);

  @override
  List<Object> get props => [immeubles];
}

class ImmeubleOperationFailure extends ImmeubleState {
  final String error;

  ImmeubleOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}
