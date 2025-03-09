import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntryModel {
  final String id;
  final String userId;
  final String mood;
  final String? note;
  final DateTime createdAt;

  MoodEntryModel({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) {
    return MoodEntryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mood: json['mood'] as String,
      note: json['note'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mood': mood,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MoodEntryModel copyWith({
    String? id,
    String? userId,
    String? mood,
    String? note,
    DateTime? createdAt,
  }) {
    return MoodEntryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
