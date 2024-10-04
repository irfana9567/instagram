import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/common/constants/colors.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/user_account.dart';
import 'package:instagram/first_page.dart';
import 'package:instagram/navigation/add_post.dart';
import 'package:instagram/navigation/home_page.dart';
import 'package:instagram/navigation/profile.dart';
import 'package:instagram/navigation/search.dart';
import 'package:instagram/model/user_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({this.selectedIndex=0});
  final int selectedIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectIndex=0;
  late int currentIndex;
  List pages=[
    const HomePage(),
    const Search(),
    const AddPost(),
    const Profile(),
  ];
  @override
  void initState() {
    currentIndex=widget.selectedIndex;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar:BottomNavigationBar(

          selectedItemColor:Colors.black,
          backgroundColor: AppColors.lightColor,
          // unselectedItemColor: ,
          showSelectedLabels:true ,
          showUnselectedLabels:true ,
          currentIndex:currentIndex ,
          onTap:(value) {
            currentIndex=value;
            setState(() {

            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon:Icon(Icons.home_filled),
                label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.search),
                label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.add_box_outlined,),
              label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.person),
                label: ""
            ),
          ]
      ) ,
    );
  }
}
