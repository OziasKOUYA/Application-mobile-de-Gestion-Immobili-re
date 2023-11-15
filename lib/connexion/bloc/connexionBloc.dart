import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../connexionUtils.dart';

part 'connexionEvent.dart';
part 'connexionState.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnexionState> {
  ConnectionBloc() : super(ConnectionInitialState()) {
    checkConnection();
  }

  Future<void> checkConnection() async {
    final isConnected = await InternetConnectivity.isConnected();
    if (isConnected) {
      emit(ConnectionSuccessState());
    } else {
      emit(ConnectionFailureState());
    }
  }
}