import 'package:flutter/cupertino.dart';
import 'package:instagram/common/constants/constant.dart';

class ListLayout extends StatelessWidget {
  const ListLayout({super.key,
    required this.itemCount,
    required this.itemBuilder
  });

  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => SizedBox(height: AppSize.scrHeight*0.02,),
        itemCount: itemCount
    );
  }
}
