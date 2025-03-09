import 'package:flutter/material.dart';
import 'package:tiktok_final/models/mood_entry_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class MoodEntryCard extends StatelessWidget {
  final MoodEntryModel moodEntry;
  final VoidCallback onLongPress;

  const MoodEntryCard({
    super.key,
    required this.moodEntry,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF5F9EA0), // Teal/green color
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.black, width: 2.0), // Thicker border
          boxShadow: [], // Remove shadow
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Mood: ${moodEntry.mood}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (moodEntry.note != null && moodEntry.note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    moodEntry.note!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodEntryCardWithTimestamp extends StatelessWidget {
  final MoodEntryModel moodEntry;
  final VoidCallback onLongPress;

  const MoodEntryCardWithTimestamp({
    super.key,
    required this.moodEntry,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MoodEntryCard(
          moodEntry: moodEntry,
          onLongPress: onLongPress,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            timeago.format(moodEntry.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
