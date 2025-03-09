import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_final/repositories/auth_repository.dart';
import 'package:tiktok_final/repositories/mood_repository.dart';
import 'package:tiktok_final/view_models/auth_view_model.dart';
import 'package:tiktok_final/view_models/mood_view_model.dart';

// Auth providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider));
});

// Mood providers
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository();
});

final moodViewModelProvider =
    StateNotifierProvider<MoodViewModel, AsyncValue<void>>((ref) {
  return MoodViewModel(
      ref.watch(moodRepositoryProvider), ref.watch(authRepositoryProvider));
});

final userMoodEntriesProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    return Stream.value([]);
  }

  // Listen to changes in the mood view model to refresh when a new entry is created
  ref.listen(moodViewModelProvider, (previous, next) {});

  return ref.watch(moodRepositoryProvider).getMoodEntriesForUser(user.uid);
});
