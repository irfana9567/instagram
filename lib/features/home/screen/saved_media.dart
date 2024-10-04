import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/home/screen/view_post.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:instagram/features/home/screen/your_activity.dart';

import '../../../common/constants/constant.dart';
import '../../../model/user_model.dart';

class SavedMedia extends StatefulWidget {
  const SavedMedia({super.key,required this.title});
  final String title;

  @override
  State<SavedMedia> createState() => _SavedMediaState();
}

class _SavedMediaState extends State<SavedMedia> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(widget.title,style:  TextStyle(
              fontSize: AppSize.scrWidth*0.05,
              fontWeight: FontWeight.w900
          ),),
          showBackArrow: true,
        ),
        body: widget.title=="Saved"?
            Column(
          children: [
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.video_library)),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 2.0,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection("post")
                          .where("saveUser",arrayContains:currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child:CircularProgressIndicator());
                        }
                        var data = snapshot.data!.docs;
                        return  GridView.builder(
                          itemCount: data.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewPost(
                                //   postUrl: data[index]["image"],
                                //   userId:  data[index]["uId"],
                                //   initialIndex: index, postId: '',
                                //   // postDetails: data,
                                // ),));
                              },
                              child: Container(
                                decoration:   BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(data[index]["image"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                      }
                  ),



                  // Second tab (Reels)
                  const Center(
                    child: Text('Reels View'),
                  ),
                ],
              ),
            ),
          ],
        )
            :Container(
          // height: AppSize.scrHeight*0.3,
          // width: AppSize.scrWidth*1,
          padding: EdgeInsets.all(AppSize.scrWidth*0.03),
          color: Colors.white,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const YourActivity(),));
                },
                child: ListTile(
                  title: const Text("Liked post",style: TextStyle(
                      color: Colors.black
                  ),),
                  trailing: Icon(Icons.arrow_forward_ios,size: AppSize.scrWidth*0.04,color: Colors.grey,),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => const YourActivity(title: 'Comments',),));
              //   },
              //   child: ListTile(
              //     title: const Text("Comments",style: TextStyle(
              //         color: Colors.black
              //     ),),
              //     trailing: Icon(Icons.arrow_forward_ios,size: AppSize.scrWidth*0.04,color: Colors.grey,),
              //   ),
              // ),
              // SizedBox(height: scrHeight*0.01,)
            ],
          ),
        ),


      ),
    );
  }
}
