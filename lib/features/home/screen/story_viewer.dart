import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/model/user_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../common/constants/constant.dart';
import '../../../common/constants/imagesConst.dart';
import '../../../common/constants/text.dart';
import '../controller/home_controller.dart';

class StoryViewer extends ConsumerStatefulWidget {
  const StoryViewer({super.key,this.imageUrl, this.docId, this.userProfile, this.userName, this.userId, this.createdAt});

  final String? imageUrl;
  final String? userProfile;
  final String? userName;
  final String? userId;
  final String? docId;
  final DateTime? createdAt;  // Added to check if story is expired

  @override
  ConsumerState<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends ConsumerState<StoryViewer> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Automatically pop the screen after 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });

  }


  delete() {
    ref.read(homeControllerProvider.notifier).deleteStory(context: context, docId: widget.docId!);
  }

  @override
  void dispose() {
    _timer.cancel();  // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: AppSize.scrHeight,
                    width: AppSize.scrWidth,
                    child: Image(
                      image: NetworkImage(widget.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left:0,
                      child:   LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width,
                        animation: true,
                        lineHeight: 2.0,
                        animationDuration: 5000,
                        percent: 1.0,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.grey,
                      ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Row(
                      children: [
                        widget.userProfile != ''
                            ? CircleAvatar(backgroundImage: NetworkImage(widget.userProfile!))
                            : const CircleAvatar(backgroundImage: AssetImage("assets/images/person.png")),
                        SizedBox(width: AppSize.scrWidth * 0.03),
                        Text(widget.userName!, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 13,
                    right: 10,
                    child: widget.userId == currentUserId
                        ? PopupMenuButton<String>(
                      icon: SizedBox(
                        height: AppSize.scrHeight * 0.03,
                        width: AppSize.scrWidth * 0.06,
                        child: SvgPicture.asset(iconConst.dots, color: Colors.white),
                      ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          AppsHelper.showAlert("Do you want to delete this?", context, true, delete);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete', style: Theme.of(context).textTheme.titleSmall),
                          ),
                        ];
                      },
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Widget buildBars(int count, List<double> precents) {
//   return Padding(
//     padding: const EdgeInsets.only(
//       top: 40,
//       left: 4,
//       right: 4,
//       bottom: 10,
//     ),
//     child: Row(
//       children: [
//         for (int i = 0; i < count; i++)
//           Expanded(
//             child: LinearPercentIndicator(
//               progressColor: Colors.deepPurple,
//               backgroundColor: const Color.fromARGB(255, 226, 226, 226),
//               lineHeight: 7.5,
//               percent: precents[i],
//               barRadius: const Radius.circular(10.0),
//             ),
//           )
//       ],
//     ),
//   );
// }