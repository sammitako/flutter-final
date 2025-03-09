import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_final/repositories/auth_repository.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(const AsyncData(null));

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signUp(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signIn(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }
}
