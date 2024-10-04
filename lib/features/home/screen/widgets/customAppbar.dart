import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/common/constants/text.dart';

import '../../../../common/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key,
    this.title,
    this.showBackArrow = false,
    this.showDrawer = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.tabItems = const [],
    this.showTabBar = false,
  });

  final Widget? title;
  final bool showBackArrow,showTabBar,showDrawer;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final List<String> tabItems;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = AppsHelper.isDarkMood(context);
    return  Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 5),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back),color: dark ? AppColors.lightColor : AppColors.darkColor,)
            : leadingIcon != null
            ? IconButton(onPressed: ()=> leadingOnPressed, icon:  Icon(leadingIcon))
            : showDrawer == true
            ? Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu,color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        )
            : null,
        title: title,
        bottom: showTabBar
            ? TabBar(isScrollable: false, tabs: tabItems.map((title) => Tab(child: Center(child: Text(title,style: Theme.of(context).textTheme.labelMedium)),),).toList(),)
            : null,
        actions: actions,
      ),

    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (showTabBar ? kToolbarHeight : 0));
}