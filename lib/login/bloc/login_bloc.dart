import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../authentification/authenticationService.dart';
import '../../exceptions/authenticationException.dart';
import '../models/password.dart';
import '../models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationService authenticationService,
  })
      : _authenticationService = authenticationService,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationService _authenticationService;

  void _onUsernameChanged(LoginUsernameChanged event,
      Emitter<LoginState> emit,) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
      ),
    );
  }

  void _onPasswordChanged(LoginPasswordChanged event,
      Emitter<LoginState> emit,) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(LoginSubmitted event,
      Emitter<LoginState> emit,) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationService.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));

      } catch (e) {
        print(e);
        if (e is AuthenticationException) {
          emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.message));
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: 'Une erreur inconnue s\'est produite.'));
        }
      }
    }
  }
}
