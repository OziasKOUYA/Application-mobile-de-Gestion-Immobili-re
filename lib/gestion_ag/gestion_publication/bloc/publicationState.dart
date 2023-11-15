part of 'publicationBloc.dart'; // Make sure to use the correct file name for your bloc

abstract class PublicationState extends Equatable {
  const PublicationState();
}

class PublicationInitial extends PublicationState {
  @override
  List<Object> get props => [];
}

class PublicationLoadInProgress extends PublicationState {
  @override
  List<Object> get props => [];
}

class PublicationLoadSuccess extends PublicationState {
  final List<PublicationRes> publications;

  const PublicationLoadSuccess([this.publications = const []]);

  @override
  List<Object> get props => [publications];
}

class PublicationOperationFailure extends PublicationState {
  final String error;

  PublicationOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}
