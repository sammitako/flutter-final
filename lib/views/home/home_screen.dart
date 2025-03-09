import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_final/models/mood_entry_model.dart';
import 'package:tiktok_final/providers.dart';
import 'package:tiktok_final/views/home/mood_entry_card.dart';
import 'package:tiktok_final/views/widgets/custom_bottom_nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to post screen
      context.go('/post');
    }
  }

  void _showDeleteDialog(MoodEntryModel moodEntry) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Delete note'),
        message: const Text('Are you sure you want to do this?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              // Delete the mood entry
              ref
                  .read(moodViewModelProvider.notifier)
                  .deleteMoodEntry(moodEntry.id);
              Navigator.of(context).pop();
            },
            isDestructiveAction: true,
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final moodEntriesAsyncValue = ref.watch(userMoodEntriesProvider);

    // Debug print
    print('Current user ID: ${user?.uid}');
    print('Mood entries async value: ${moodEntriesAsyncValue.toString()}');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      appBar: AppBar(
        title: const Text(
          '🔥 MOOD 🔥',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: moodEntriesAsyncValue.when(
        data: (moodEntries) {
          // Debug print
          print('Mood entries count: ${moodEntries.length}');
          for (var entry in moodEntries) {
            print(
                'Mood entry userId: ${entry.userId}, current user: ${user?.uid}');
          }

          // Filter entries to only show the current user's entries
          final userMoodEntries =
              moodEntries.where((entry) => entry.userId == user?.uid).toList();

          if (userMoodEntries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Record your first mood',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tap the pencil icon below to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: userMoodEntries.length,
            itemBuilder: (context, index) {
              final moodEntry = userMoodEntries[index];
              return MoodEntryCardWithTimestamp(
                moodEntry: moodEntry,
                onLongPress: () => _showDeleteDialog(moodEntry),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
