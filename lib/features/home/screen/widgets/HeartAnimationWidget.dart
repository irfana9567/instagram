// import 'package:flutter/material.dart';
//
// class HeartAnimationWidget extends StatefulWidget {
//   final Widget child;
//   final bool isAnimating;
//   final bool alwaysAnimate;
//   final Duration duration;
//   final VoidCallback? onEnd;
//   const HeartAnimationWidget({
//     Key?key,
//     required this.child,
//     required this.isAnimating,
//     this.alwaysAnimate = false,
//     this.duration= const Duration(milliseconds: 150),
//     this.onEnd,
//   }):super(key:key);
//
//   @override
//   State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
// }
//
// class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
// with SingleTickerProviderStateMixin{
//   late AnimationController controller;
//   late Animation<double> scale;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final halfDuration=widget.duration.inMilliseconds ~/ 2 ;
//     controller=AnimationController(
//       vsync:this ,
//       duration: Duration(milliseconds:halfDuration ),
//     );
//
//     scale =Tween<double>(begin: 1,end: 1.2).animate(controller);
//   }
//   @override
//   void didUpdateWidget(HeartAnimationWidget oldWidget){
//     super.didUpdateWidget(oldWidget);
//     if(widget.isAnimating !=oldWidget.isAnimating){
//       doAnimation();
//     }
//   }
//
//   Future doAnimation()async{
//     if(widget.isAnimating || widget.alwaysAnimate){
//       await controller.forward();
//       await controller.reverse();
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       if(widget.onEnd !=null){
//         widget.onEnd!();
//       }
//     }
//   }
//
//   @override
//   void dispose(){
//     controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) => ScaleTransition(
//       scale: scale,
//       child: widget.child
//   );
// }

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
