import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/datasource/auth_data_source.dart';
import 'auth_status_state.dart';

class AuthStatusCubit extends Cubit<AuthStatusState> {
  final AuthDataSource _authDataSource;
  StreamSubscription? _sub;

  AuthStatusCubit({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource,
        super(AuthStatusUnknown());

  /// Инициализация: первая проверка + подписка на изменения авторизации.
  /// Вызывать один раз (например, из MainScreen).
  void init() {
    // Реакция на sign-in / sign-out / token refresh
    _sub?.cancel();
    _sub = _authDataSource.authStatusStream().listen(
          (event) {
        if (event.event == AuthChangeEvent.signedOut) {
          emit(AuthStatusUnauthorized());
        } else {
          checkStatus();
        }
      },
      onError: (e) => debugPrint('auth state stream error: $e'),
    );
    //checkStatus();
  }

  Future<void> checkStatus() async {
    //emit(AuthStatusChecking());
    final status = await _authDataSource.checkStatus();
    switch (status) {
      case AppAuthStatus.fullyAuthorized:
        emit(AuthStatusAuthorized());
      case AppAuthStatus.incomplete:
        emit(AuthStatusIncomplete());
      case AppAuthStatus.unauthorized:
        emit(AuthStatusUnauthorized());
    }
    print('status ${state}');
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}