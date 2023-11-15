part of 'publicationBloc.dart'; // Make sure to use the correct file name for your bloc

abstract class PublicationEvent extends Equatable {
  const PublicationEvent();
}

class LoadPublications extends PublicationEvent {
  final int id;
  const LoadPublications({required this.id});
  @override
  List<Object> get props => [id];
}

class AddPublication extends PublicationEvent {
  final int id;
  final Publication publication;
  final File? image;

  const AddPublication(this.id, this.publication,this.image);

  @override
  List<Object> get props => [id, publication];
}

class UpdatePublication extends PublicationEvent {
  final int id;
  final Publication publication;

  const UpdatePublication(this.id, this.publication);

  @override
  List<Object> get props => [id, publication];
}

class DeletePublication extends PublicationEvent {
  final int idPublication;
  final int id;

  const DeletePublication(this.id, this.idPublication);

  @override
  List<Object> get props => [idPublication];
}
