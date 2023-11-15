part of 'immeubleBloc.dart';

abstract class ImmeubleEvent extends Equatable {
  const ImmeubleEvent();
}

class LoadImmeubles extends ImmeubleEvent {
  final int id;
  const LoadImmeubles({required this.id});
  @override
  List<Object> get props => [id];
}

class AddImmeuble extends ImmeubleEvent {
  final int id;
  final Immeuble immeuble;

  const AddImmeuble(this.id, this.immeuble);

  @override
  List<Object> get props => [id, immeuble];
}

class UpdateImmeuble extends ImmeubleEvent {
  final int id;
  final Immeuble immeuble;

  const UpdateImmeuble(this.id, this.immeuble);

  @override
  List<Object> get props => [id, immeuble];
}

class DeleteImmeuble extends ImmeubleEvent {
  final int idImmeuble;
  final int id;

  const DeleteImmeuble(this.id, this.idImmeuble);

  @override
  List<Object> get props => [idImmeuble];
}
