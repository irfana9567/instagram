// //
// // import 'package:flutter/material.dart';
// //
// // class AnimatedStoryAvatar extends StatefulWidget {
// //   final String imageUrl;
// //   final String profileUrl;
// //   final bool hasStory;
// //   final VoidCallback onStoryLoadComplete;
// //
// //   AnimatedStoryAvatar({
// //     required this.imageUrl,
// //     required this.profileUrl,
// //     this.hasStory = false,
// //     required this.onStoryLoadComplete,
// //   });
// //
// //   @override
// //   _AnimatedStoryAvatarState createState() => _AnimatedStoryAvatarState();
// // }
// //
// // class _AnimatedStoryAvatarState extends State<AnimatedStoryAvatar>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   bool _isLoading = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: Duration(seconds: 4), // Speed of animation
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   // Simulate loading the story (or image) on tap
// //   Future<void> _loadStory() async {
// //     setState(() {
// //       _isLoading = true; // Start loading animation
// //     });
// //     _controller.repeat(); // Start the animation
// //
// //     // Simulate loading delay (e.g., fetching a story from server)
// //     await Future.delayed(Duration(seconds: 2));
// //
// //     // Stop the animation and indicate loading is complete
// //     _controller.stop();
// //     setState(() {
// //       _isLoading = false;
// //     });
// //
// //     // Call the onStoryLoadComplete to perform further actions (like showing the story)
// //     widget.onStoryLoadComplete();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: _loadStory, // Start loading on tap
// //       child: AnimatedBuilder(
// //         animation: _controller,
// //         builder: (context, child) {
// //           return Container(
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               gradient: _isLoading && widget.hasStory
// //                   ? SweepGradient(
// //                 colors: [
// //                   Colors.red,
// //                   Colors.orange,
// //                   Colors.yellow,
// //                   Colors.purple,
// //                   Colors.red,
// //                 ],
// //                 stops: [0.0, 0.25, 0.5, 0.75, 1.0],
// //                 transform: GradientRotation(_controller.value * 6.3), // Animate the gradient
// //               )
// //                   : null, // Apply gradient only if loading and has a story
// //               border: Border.all(
// //                 color: Colors.white, // Inner white border
// //                 width: 3.0,
// //               ),
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(3.0),
// //               child: CircleAvatar(
// //                 radius: 40,
// //                 backgroundImage: NetworkImage(widget.imageUrl),
// //                 backgroundColor: Colors.grey[200],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// class AnimatedStoryAvatar extends StatefulWidget {
//   final String imageUrl;
//   final String profileUrl;
//   final bool hasStory;
//   final VoidCallback onStoryLoadComplete;
//
//   AnimatedStoryAvatar({
//     required this.imageUrl,
//     required this.profileUrl,
//     this.hasStory = false,
//     required this.onStoryLoadComplete,
//   });
//
//   @override
//   _AnimatedStoryAvatarState createState() => _AnimatedStoryAvatarState();
// }
//
// class _AnimatedStoryAvatarState extends State<AnimatedStoryAvatar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4), // Speed of animation
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // Simulate loading the story (or image) on tap
//   Future<void> _loadStory() async {
//     setState(() {
//       _isLoading = true; // Start loading animation
//     });
//     _controller.repeat(); // Start the animation
//
//     // Simulate loading delay (e.g., fetching a story from server)
//     await Future.delayed(Duration(seconds: 2));
//
//     // Stop the animation and indicate loading is complete
//     _controller.stop();
//     setState(() {
//       _isLoading = false;
//     });
//
//     // Call the onStoryLoadComplete to perform further actions (like showing the story)
//     widget.onStoryLoadComplete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _loadStory, // Start loading on tap
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: widget.hasStory
//                   ? SweepGradient(
//                 colors: _isLoading
//                     ? [
//                   Colors.red,
//                   Colors.orange,
//                   Colors.yellow,
//                   Colors.purple,
//                   Colors.red,
//                 ]
//                     : [
//                   Colors.pink,
//                   Colors.orange,
//                   Colors.yellow,
//                   Colors.purple,
//                   Colors.pink,
//                 ], // Different colors for loading vs idle state
//                 stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
//                 transform: _isLoading
//                     ? GradientRotation(_controller.value * 6.3) // Animated rotation
//                     : const GradientRotation(0), // Static if not loading
//               )
//                   : null, // Apply gradient only if there's a story
//               border: Border.all(
//                 color: Colors.white, // Inner white border
//                 width: 3.0,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: CircleAvatar(
//                 radius: 40,
//                 backgroundImage: NetworkImage(widget.imageUrl),
//                 backgroundColor: Colors.grey[200],
//                 foregroundImage: widget.profileUrl!=""?NetworkImage(widget.profileUrl): const AssetImage("assets/images/person.png"),
//                 foregroundColor: Colors.grey[200],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class AnimatedStoryAvatar extends StatefulWidget {
  final String imageUrl;
  final String profileUrl;
  final bool hasStory;
  final VoidCallback onStoryLoadComplete;

  AnimatedStoryAvatar({
    required this.imageUrl,
    required this.profileUrl,
    this.hasStory = false,
    required this.onStoryLoadComplete,
  });

  @override
  _AnimatedStoryAvatarState createState() => _AnimatedStoryAvatarState();
}

class _AnimatedStoryAvatarState extends State<AnimatedStoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;
  bool _hasSeenStory = false; // Flag to check if the story has been seen

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Speed of animation
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Simulate loading the story (or image) on tap
  Future<void> _loadStory() async {
    setState(() {
      _isLoading = true; // Start loading animation
    });
    _controller.repeat(); // Start the animation

    // Simulate loading delay (e.g., fetching a story from server)
    await Future.delayed(Duration(seconds: 2));

    // Stop the animation and indicate loading is complete
    _controller.stop();
    setState(() {
      _isLoading = false;
      _hasSeenStory = true; // Set the story as seen
    });

    // Call the onStoryLoadComplete to perform further actions (like showing the story)
    widget.onStoryLoadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.hasStory && !_hasSeenStory ? _loadStory : null, // Start loading on tap if the story hasn't been seen
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.hasStory
                  ? (_hasSeenStory
                  ? const LinearGradient( // Once seen, apply grey gradient
                colors: [
                  Colors.grey,
                  Colors.grey,
                ],
              )
                  : SweepGradient(
                colors: _isLoading
                    ? [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.purple,
                  Colors.red,
                ]
                    : [
                  Colors.pink,
                  Colors.orange,
                  Colors.yellow,
                  Colors.purple,
                  Colors.pink,
                ], // Different colors for loading vs idle state
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                transform: _isLoading
                    ? GradientRotation(_controller.value * 6.3) // Animated rotation
                    : const GradientRotation(0), // Static if not loading
              ))
                  : null, // Apply gradient only if there's a story
              border: Border.all(
                color: Colors.white, // Inner white border
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.imageUrl),
                backgroundColor: Colors.grey[200],
                foregroundImage: widget.profileUrl != ""
                    ? NetworkImage(widget.profileUrl)
                    : const AssetImage("assets/images/person.png"),
                foregroundColor: Colors.grey[200],
              ),
            ),
          );
        },
      ),
    );
  }
}
