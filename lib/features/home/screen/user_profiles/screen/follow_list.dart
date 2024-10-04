import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/constants/constant.dart';
import '../../widgets/lay_out.dart';

class FollowList extends StatefulWidget {
  const FollowList({super.key,required this.followerList,required this.followingList,});
  final List followerList;
  final List followingList;
  // final String name;

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  @override
  void initState() {
    print(widget.followerList);
    print("aaaaaaaaaaaaaaaaaa");
    print(widget.followerList[0]["userName"]);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(""),
        ),
        body:  Column(
          children: [
             const TabBar(
              tabs: [
                Tab(text: "followers",),
                Tab(text: "following",),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 2.0,
            ),
              Expanded(
                child: TabBarView(
                   children: [
                     ///followers tab
                     ListLayout(
                         itemCount: widget.followerList.length,
                         itemBuilder: (context, index) {
                           return SizedBox(
                             height: AppSize.scrHeight * 0.1,
                             width: AppSize.scrWidth * 1,
                             child:  ListTile(
                               leading:widget.followerList[index]["profile"]!=""? CircleAvatar(
                                   radius: 28,
                                   backgroundImage: NetworkImage(widget.followerList[index]["profile"])
                               ) :const CircleAvatar(radius: 28, backgroundImage:AssetImage("assets/images/person.png") ,),
                               title:  Text(widget.followerList[index]["userName"]),
                               subtitle:  Text(widget.followerList[index]["name"],style: const TextStyle(color: Colors.grey,),),
                               trailing: Container(
                                 height: AppSize.scrHeight * 0.04,
                                 width: AppSize.scrWidth * 0.32,
                                 decoration: BoxDecoration(
                                   color: Colors.blueAccent,
                                   borderRadius: BorderRadius.circular(AppSize.scrWidth * 0.02),
                                 ),
                                 child: const Center(
                                   child: Text('Follow',
                                     style: TextStyle(
                                       color:  Colors.white,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         }
                     ),
                     ///following tab
                     ListLayout(
                         itemCount: widget.followingList.length,
                         itemBuilder: (context, index) {
                           return SizedBox(
                             height: AppSize.scrHeight * 0.1,
                             width: AppSize.scrWidth * 1,
                             child:  ListTile(
                               leading: widget.followingList[index]["profile"]!=""? CircleAvatar(
                                   radius: 28,
                                   backgroundImage: NetworkImage(widget.followingList[index]["profile"])
                               ) :const CircleAvatar(radius: 28, backgroundImage:AssetImage("assets/images/person.png") ,),
                               title:  Text(widget.followingList[index]["userName"]),
                               subtitle:  Text(widget.followingList[index]["name"],style: const TextStyle(color: Colors.grey,),),
                               trailing: Container(
                                 height: AppSize.scrHeight * 0.04,
                                 width: AppSize.scrWidth * 0.32,
                                 decoration: BoxDecoration(
                                   color: Colors.blueAccent,
                                   borderRadius: BorderRadius.circular(AppSize.scrWidth * 0.02),
                                 ),
                                 child: const Center(
                                   child: Text('Following',
                                     style: TextStyle(
                                       color:  Colors.white,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         }
                     ),

                   ]),
              )
          ],
        ),
      ),
    );
  }
}

