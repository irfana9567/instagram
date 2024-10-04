import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/features/home/controller/home_controller.dart';

import '../../../common/constants/constant.dart';

class YourActivity extends ConsumerStatefulWidget {
  const YourActivity({super.key,});

  @override
  ConsumerState<YourActivity> createState() => _YourActivityState();
}

class _YourActivityState extends ConsumerState<YourActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked Post", style: TextStyle(
            fontSize: AppSize.scrWidth*0.05,
            fontWeight: FontWeight.w900
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ref.watch(likedPosts).when(
              data: (data) {
                return SizedBox(
                  height: AppSize.scrHeight,
                  child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration:   BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(data[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }
}
