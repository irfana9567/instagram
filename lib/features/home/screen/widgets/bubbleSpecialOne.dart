import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class CustomBubbleSpecialOne extends BubbleSpecialOne {
  const CustomBubbleSpecialOne({
    super.key,
    required super.text,
    required super.isSender,
    required super.color,
    required super.textStyle,
    this.trailing,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment
          .start,
      children:
      [
        super.build(context),
        if (trailing != null) trailing!,
      ],
    );
  }
}