import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../model/user_model.dart';
import '../repository/follow_repository.dart';
import '../../../../../first_page.dart'; // Assuming currentUserIdProvider is here

final followControllerProvider = StateNotifierProvider.family<FollowController, bool, String>((ref, otherUserId) {
  return FollowController(
    followRepository: ref.watch(followRepositoryProvider),
    currentUserId: currentUserId,
    otherUserId: otherUserId,
  );
});

class FollowController extends StateNotifier<bool> {
  final FollowRepository _followRepository;
  final String currentUserId;
  final String otherUserId;

  FollowController({
    required FollowRepository followRepository,
    required this.currentUserId,
    required this.otherUserId,
  })  : _followRepository = followRepository,
        super(false) {
    _checkFollowStatus();
  }

  // Check if the user is already following
  Future<void> _checkFollowStatus() async {
    try {
      bool isFollowing = await _followRepository.isFollowing(currentUserId, otherUserId);
      state = isFollowing;
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  // Toggle follow/unfollow
  Future<void> toggleFollow() async {
    try {
      if (state) {
        await _followRepository.unfollowUser(currentUserId, otherUserId);
      } else {
        await _followRepository.followUser(currentUserId, otherUserId);
      }
      state = !state;
    } catch (e) {
      print('Error toggling follow status: $e');
    }
  }
}
