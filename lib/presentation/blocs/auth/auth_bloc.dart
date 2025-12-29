import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_current_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/usecases/login.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final GetCurrentUser getCurrentUser;

  AuthBloc(this.login, this.getCurrentUser) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}

