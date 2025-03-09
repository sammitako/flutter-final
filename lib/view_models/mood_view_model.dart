import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_final/models/mood_entry_model.dart';
import 'package:tiktok_final/repositories/auth_repository.dart';
import 'package:tiktok_final/repositories/mood_repository.dart';
import 'package:uuid/uuid.dart';

class MoodViewModel extends StateNotifier<AsyncValue<void>> {
  final MoodRepository _moodRepository;
  final AuthRepository _authRepository;

  MoodViewModel(this._moodRepository, this._authRepository)
      : super(const AsyncData(null));

  Future<void> createMoodEntry({
    required String mood,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = _authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final moodEntry = MoodEntryModel(
        id: const Uuid().v4(),
        userId: user.uid,
        mood: mood,
        note: note,
        createdAt: DateTime.now(),
      );

      await _moodRepository.createMoodEntry(moodEntry);
    });
  }

  Future<void> deleteMoodEntry(String moodEntryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _moodRepository.deleteMoodEntry(moodEntryId);
    });
  }
}
