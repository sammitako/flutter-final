import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok_final/models/mood_entry_model.dart';

class MoodRepository {
  final FirebaseFirestore _firestore;

  MoodRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _moodCollection =>
      _firestore.collection('moods');

  Future<void> createMoodEntry(MoodEntryModel moodEntry) async {
    try {
      await _moodCollection.doc(moodEntry.id).set(moodEntry.toJson());
    } catch (e) {
      throw Exception('Failed to create mood entry: $e');
    }
  }

  Stream<List<MoodEntryModel>> getMoodEntriesForUser(String userId) {
    print('Getting mood entries for user: $userId');

    return _moodCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Snapshot size: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        print('No mood entries found for user: $userId');
        return <MoodEntryModel>[];
      }

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        final entry = MoodEntryModel.fromJson(data);
        print('Entry userId: ${entry.userId}, requested userId: $userId');
        return entry;
      }).toList();

      // Sort in memory instead of using orderBy to avoid requiring an index
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Filter again to ensure only the correct user's entries are returned
      final filteredEntries =
          entries.where((entry) => entry.userId == userId).toList();
      print('Filtered entries count: ${filteredEntries.length}');

      return filteredEntries;
    });
  }

  Future<void> deleteMoodEntry(String moodEntryId) async {
    try {
      await _moodCollection.doc(moodEntryId).delete();
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }
}
