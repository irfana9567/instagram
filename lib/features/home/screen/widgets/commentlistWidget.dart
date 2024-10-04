import 'package:flutter/material.dart';
import 'package:instagram/model/user_model.dart';
TextEditingController commentController=TextEditingController();



// dynamic formatTimestamp(DateTime timestamp) {
//   Duration diff = DateTime.now().difference(timestamp);
//   if (diff.inMinutes < 60) {
//     return "${diff.inMinutes}m ago";
//   } else if (diff.inHours < 24) {
//     return "${diff.inHours}h ago";
//   }
