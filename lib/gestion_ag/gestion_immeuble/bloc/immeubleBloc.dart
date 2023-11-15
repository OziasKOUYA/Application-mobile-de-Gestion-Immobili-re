import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../connexion/bloc/connexionBloc.dart';
import '../models/Immeuble.dart';
import '../immeubleService.dart';

part 'immeubleEvent.dart';
part 'immeubleState.dart';

class ImmeubleBloc extends Bloc<ImmeubleEvent, ImmeubleState> {
  final ImmeubleService immeubleService;
  final ConnectionBloc connectionBloc;
  final BuildContext context;

  ImmeubleBloc({required this.immeubleService, required this.connectionBloc, required this.context})
      : super(ImmeubleLoadInProgress()) {
    on<LoadImmeubles>(_onImmeublesLoaded);
    on<AddImmeuble>(_onImmeubleAdded);
    on<UpdateImmeuble>(_onImmeubleUpdated);
    on<DeleteImmeuble>(_onImmeubleDeleted);
  }

  Future<void> _onImmeublesLoaded(
      LoadImmeubles event,
      Emitter<ImmeubleState> emit,
      ) async {
    try {
      final immeubles = await immeubleService.getImmeubles(event.id, context);
      emit(ImmeubleLoadSuccess(immeubles));
    } catch (e) {
      emit(ImmeubleOperationFailure(e.toString()));
    }
  }

  Future<void> _onImmeubleAdded(
      AddImmeuble event,
      Emitter<ImmeubleState> emit,
      ) async {
    try {
      await immeubleService.addImmeuble(event.id, event.immeuble, context);
      final immeubles = await immeubleService.getImmeubles(event.id, context);
      emit(ImmeubleLoadSuccess(immeubles));
    } catch (e) {
      emit(ImmeubleOperationFailure(e.toString()));
    }
  }

  Future<void> _onImmeubleUpdated(
      UpdateImmeuble event,
      Emitter<ImmeubleState> emit,
      ) async {
    try {
      await immeubleService.updateImmeuble(event.id, event.immeuble, context);
      final immeubles = await immeubleService.getImmeubles(event.id, context);
      emit(ImmeubleLoadSuccess(immeubles));
    } catch (e) {
      emit(ImmeubleOperationFailure(e.toString()));
    }
  }

  Future<void> _onImmeubleDeleted(
      DeleteImmeuble event,
      Emitter<ImmeubleState> emit,
      ) async {
    try {
      await immeubleService.deleteImmeuble(event.idImmeuble, context);
      final immeubles = await immeubleService.getImmeubles(event.id, context);
      emit(ImmeubleLoadSuccess(immeubles));
    } catch (e) {
      emit(ImmeubleOperationFailure(e.toString()));
    }
  }
}
