import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_immobiliere/register/models/Utilisateur.dart';
import 'dart:io';

import '../registerService.dart';

part 'registerEvent.dart';
part 'registerState.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterService registerService;

  RegisterBloc({required this.registerService}) : super(RegisterInitial()) {
    on<RegisterClientEvent>(_onRegisterClientEvent);
    on<RegisterGerantEvent>(_onRegisterGerantEvent);
    on<GetClientEvent>(_onGetClientEvent);
    on<GetGerantEvent>(_onGetGerantEvent);
  }

  Future<void> _onRegisterClientEvent(
      RegisterClientEvent event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      await registerService.registerClient(
        event.utilisateur,
        );
      emit(RegisterSuccess());
    } catch (error) {
      emit(RegisterFailure(error.toString()));
    }
  }


  Future<void> _onRegisterGerantEvent(
      RegisterGerantEvent event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      await registerService.registerGerant(
        event.utilisateur,
      );
      emit(RegisterSuccess());
    } catch (error) {
      emit(RegisterFailure(error.toString()));
    }
  }
  Future<void> _onGetClientEvent(
      GetClientEvent event,
      Emitter<RegisterState> emit,
      ) async {
    try {
      final client = await registerService.getClientById(event.id);
      emit(GetClientSuccess(utilisateur: client));
    } catch (e) {
      emit(GetUtilisateurFailure(e.toString()));
      print(e.toString());
    }
  }

  Future<void> _onGetGerantEvent(
      GetGerantEvent event,
      Emitter<RegisterState> emit,
      ) async {
    try {
      final client = await registerService.getGerantById(event.id);
      emit(GetGerantSuccess(utilisateur: client));
    } catch (e) {
      emit(GetUtilisateurFailure(e.toString()));
      print(e.toString());
    }
  }



}

