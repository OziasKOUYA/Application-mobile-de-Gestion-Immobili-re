import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../connexion/bloc/connexionBloc.dart';
import '../models/Publication.dart';
import '../models/PublicationRes.dart';
import '../publicationService.dart';
import 'dart:io';
part 'publicationEvent.dart';
part 'publicationState.dart';
class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  final PublicationService publicationService;
  final ConnectionBloc connectionBloc;
  final BuildContext context;

  PublicationBloc({
    required this.publicationService,
    required this.connectionBloc,
    required this.context,
  }) : super(PublicationLoadInProgress()) {
    on<LoadPublications>(_onPublicationsLoaded);
    on<AddPublication>(_onPublicationAdded);
    on<UpdatePublication>(_onPublicationUpdated);
    on<DeletePublication>(_onPublicationDeleted);
  }

  Future<void> _onPublicationsLoaded(
      LoadPublications event,
      Emitter<PublicationState> emit,
      ) async {
    try {
      emit(PublicationLoadInProgress());
      final publications = await publicationService.getPublications( context);
      emit(PublicationLoadSuccess(publications));
    } catch (e) {
      print(e.toString());
      emit(PublicationOperationFailure(e.toString()));
    }
  }

  Future<void> _onPublicationAdded(
      AddPublication event,
      Emitter<PublicationState> emit,
      ) async {
    try {
      emit(PublicationLoadInProgress());
      await publicationService.addPublication(event.id, event.publication, context,event.image);
      final publications = await publicationService.getPublications(context);
      emit(PublicationLoadSuccess(publications));
    } catch (e) {
      print(e.toString());
      emit(PublicationOperationFailure(e.toString()));
    }
  }

  Future<void> _onPublicationUpdated(
      UpdatePublication event,
      Emitter<PublicationState> emit,
      ) async {
    try {
      emit(PublicationLoadInProgress());
      await publicationService.updatePublication(event.id, event.publication, context);
      final publications = await publicationService.getPublications( context);
      emit(PublicationLoadSuccess(publications));
    } catch (e) {
      print(e.toString());
      emit(PublicationOperationFailure(e.toString()));
    }
  }

  Future<void> _onPublicationDeleted(
      DeletePublication event,
      Emitter<PublicationState> emit,
      ) async {
    try {
      emit(PublicationLoadInProgress());
      await publicationService.deletePublication(event.idPublication, context);
      final publications = await publicationService.getPublications( context);
      emit(PublicationLoadSuccess(publications));
    } catch (e) {
      print(e.toString());
      emit(PublicationOperationFailure(e.toString()));
    }
  }
}
