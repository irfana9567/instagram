import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/features/home/screen/widgets/story_avatar.dart';
import '../../controller/home_controller.dart';
import '../story_viewer.dart';

class StoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(getStory);

    return storyAsyncValue.when(
      data: (stories) {
        // Safeguard in case the stories list is empty
        // if (stories.isEmpty) {
        //   return const Center(child: Text('No stories available'));
        // }
        return Row(
          children: stories.map((story) {
            final DateTime now = DateTime.now();
            final DateTime createdAt = story.createdAt;
            final bool isExpired = now.difference(createdAt).inHours >= 24;

            // if (!isExpired) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    AnimatedStoryAvatar(
                      imageUrl: story.media,
                      profileUrl: story.userProfile,
                      hasStory: true,
                      onStoryLoadComplete: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryViewer(
                              imageUrl: story.media,
                              userName: story.userName,
                              userProfile: story.userProfile,
                              userId: story.uId,
                              createdAt: story.createdAt, // Pass the createdAt date
                              docId: story.mId,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.userName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            // } else {
            //   return const SizedBox();
            // }
          }).toList(),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
