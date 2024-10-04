import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/common/constants/imagesConst.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/features/home/screen/user_profiles/controller/follow_controller.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/follow_list.dart';
import 'package:instagram/features/home/screen/view_post.dart';
import 'package:instagram/model/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../model/user_model.dart';
import '../../../../auth/screen/login_page.dart';
import '../../edit_profile.dart';

class UserAccount extends ConsumerStatefulWidget {
  const UserAccount({super.key,required this.userProfile,required this.userName,required this.postCount,required this.userBio, required this.name, required this.userId});
  final String userProfile;
  final String userName;
  final String name;
  final String userId;
  final String userBio;
  final int? postCount;

  @override
  ConsumerState<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends ConsumerState<UserAccount> {

  String _value='one';
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    currentUserId='';
    currentUser=null;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(),), (route) => false,);

  }
  // File? file;
  // bool loading = false;
  // pickFile(ImageSource) async {
  //   final imageFile =
  //   await ImagePicker.platform.getImageFromSource(source: ImageSource);
  //   file = File(imageFile!.path);
  //   if (mounted) {
  //     setState(() {
  //       file = File(imageFile.path);
  //     });
  //   }
  //   uploadImage(file!);
  // }
  // String imageUrl="";
  // uploadImage(File file)async{
  //   var uploadTask=await FirebaseStorage.instance
  //       .ref("userImages")
  //       .child(DateTime.now().toString())
  //       .putFile(file,SettableMetadata(contentType: "image/jpeg"));
  //   var getImage=await uploadTask.ref.getDownloadURL();
  //   imageUrl=getImage;
  //   // FirebaseFirestore.instance.collection('users').doc(currentUserId).update({"image":imageUrl});
  // }
  //
  var file;
  String imgurl = 'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=';
  pickFile(ImageSource) async{
    final imageFile=await ImagePicker.platform.pickImage(source:ImageSource);
    file=File(imageFile!.path);
    if(mounted){
      print(file);
      setState(() {
        file=File(imageFile.path);
      });
      uploadfile(file!);
    }
  }
  uploadfile(File file) async {
    var uploadtask=await FirebaseStorage.instance.ref("user").child(DateTime.now().toString()).putFile(file,
        SettableMetadata(contentType: "image/jpg"));

    var geturl=await uploadtask.ref.getDownloadURL();
    imgurl = geturl;
    FirebaseFirestore.instance.collection("users").doc(currentUserId).update(
        {"profile":imgurl});
    setState(() {

    });
    print(geturl);
  }
  UserModel? followerData;
  followData()async{
    followerData=await ref.read(homeControllerProvider.notifier).getfollowUSer(uId: widget.userId);
  }
  
 @override
  void initState() {
    followData();
    print("ddddddddddddddd");
    // TODO: implement initState
    super.initState();
  }

  StateProvider isPressed=StateProvider((ref) => false,);
  @override
  Widget build(BuildContext context) {
    final isFollowing = ref.watch(followControllerProvider(widget.userId));
    final followController = ref.read(followControllerProvider(widget.userId).notifier);
    final isPress = ref.watch(isPressed);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:
        // currentUserId==widget.userId? AppBar(
        //     backgroundColor: Colors.white,
        //     title: DropdownButtonHideUnderline(
        //       child: DropdownButton<String>(
        //         value: _value,
        //         items: <DropdownMenuItem<String>>[
        //           DropdownMenuItem(
        //             value: 'one',
        //             child: Row(
        //               children: [
        //                 Text(currentUser?.userName??""),
        //               ],
        //             ),
        //           ),
        //         ],
        //         onChanged: (value){},
        //       ),
        //     ),
        //     actions: [
        //       InkWell(
        //           onTap: () {
        //
        //           },
        //           child: const Icon(Icons.add_box_outlined,)),
        //       InkWell(
        //           onTap: (){
        //             showModalBottomSheet(
        //                 context: context,
        //                 builder: (BuildContext context){
        //                   return Container(
        //                     height: AppSize.scrHeight/3,
        //                     color: Colors.transparent,
        //                     child: Column(
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         const InkWell(
        //                           child: ListTile(
        //                             leading: Icon(
        //                               Icons.save,
        //                               color: Colors.black,
        //                             ),
        //                             title:Text("Saved") ,
        //                           ),
        //                         ),
        //                         InkWell(
        //                           onTap: () {
        //                             showDialog(
        //                               barrierDismissible: false,
        //                               context: context,
        //                               builder: (context) {
        //                                 return AlertDialog(
        //                                   title: Text("Are you sure? you want to logout?",
        //                                     textAlign: TextAlign.center,
        //                                     style: TextStyle(
        //                                         fontSize: AppSize.scrHeight*0.02,
        //                                         fontWeight: FontWeight.w600
        //                                     ),),
        //                                   content: Row(
        //                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                                     children: [
        //                                       InkWell(
        //                                         onTap: () {
        //                                           Navigator.pop(context);
        //                                         },
        //                                         child: Container(
        //                                           height: 30,
        //                                           width: 100,
        //                                           decoration: BoxDecoration(
        //                                             color: Colors.blueGrey,
        //                                             borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03),
        //                                           ),
        //                                           child: const Center(child: Text("No",
        //                                             style: TextStyle(
        //                                                 color: Colors.white
        //                                             ),)),
        //                                         ),
        //                                       ),
        //                                       InkWell(
        //                                         onTap: () async {
        //                                           logout();
        //                                         },
        //                                         child: Container(
        //                                           height: 30,
        //                                           width: 100,
        //                                           decoration: BoxDecoration(
        //                                             color: Colors.red[800],
        //                                             borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03),
        //                                           ),
        //                                           child: const Center(child: Text("Yes",
        //                                             style: TextStyle(
        //                                                 color: Colors.white
        //                                             ),)),
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 );
        //                               },
        //                             );
        //                           },
        //                           child: const ListTile(
        //                             leading: Icon(
        //                               Icons.logout,
        //                               color: Colors.red,
        //                             ),
        //                             title: Text("Logout",style: TextStyle(color: Colors.red),),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   );
        //                 });
        //           },
        //           child: Padding(
        //             padding: EdgeInsets.all(AppSize.scrWidth*0.03),
        //             child: const Icon(Icons.list,color: Colors.black,),
        //           ))
        //     ]  ) :
        AppBar(
          title: Text(widget.userName),
          actions: [
            const Icon(Icons.notifications),
            SizedBox(width: AppSize.scrWidth*0.03,),
            SvgPicture.asset(iconConst.dots),
            SizedBox(width: AppSize.scrWidth*0.03,)
          ],
        ),
        body:   Column(
          children: [
             Padding(
              padding:  EdgeInsets.all(AppSize.scrWidth*0.05,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // currentUserId==widget.userId? Stack(
                      //   children: [
                      //     const SizedBox(
                      //       child:Column(
                      //         children: [
                      //           CircleAvatar(
                      //             radius: 40,
                      //             // backgroundImage: file!=null
                      //             //     ? NetworkImage(imgurl)
                      //             //     : const AssetImage('assets/default_profile.png'),
                      //             // backgroundColor: Colors.grey[200],
                      //             // backgroundImage: NetworkImage(imageUrl!),
                      //           ),
                      //           // file !=null?
                      //           //  CircleAvatar(
                      //           //   radius: 45,
                      //           //   backgroundImage: NetworkImage(imgurl),
                      //           // ):
                      //           // const CircleAvatar(
                      //           //   backgroundColor: Colors.grey,
                      //           //   radius: 45,
                      //           //   // backgroundImage: AssetImage('assets/default_profile.png'),
                      //           // ),
                      //         ],
                      //       ) ,
                      //     ),
                      //     Positioned(
                      //         bottom: 0,
                      //         right: 15,
                      //         child: InkWell(
                      //             onTap: () {
                      //               showDialog(
                      //                 context: context,
                      //                 builder: (context) {
                      //                   return AlertDialog(
                      //                     title: Row(
                      //                       mainAxisAlignment:
                      //                       MainAxisAlignment.spaceEvenly,
                      //                       children: [
                      //                         InkWell(
                      //                           onTap: () {
                      //                             pickFile(ImageSource.camera);
                      //                             Navigator.pop(context);
                      //                           },
                      //                           child: Column(
                      //                             children: [
                      //                               Text(
                      //                                 "Choose a file form",
                      //                                 style: TextStyle(
                      //                                     fontSize: AppSize.scrWidth * 0.04),
                      //                               ),
                      //                               SizedBox(height: AppSize.scrWidth * 0.04,),
                      //                               Row(
                      //                                 children: [
                      //                                   Container(
                      //                                     height: AppSize.scrWidth * 0.1,
                      //                                     width: AppSize.scrWidth * 0.1,
                      //                                     decoration: BoxDecoration(
                      //                                         color: Colors.white,
                      //                                         borderRadius:
                      //                                         BorderRadius.circular(
                      //                                             AppSize.scrWidth * 0.04),
                      //                                         border: Border.all(
                      //                                             color:
                      //                                             Colors.grey)),
                      //                                     child: const Icon(
                      //                                       Icons.camera_alt_outlined,
                      //                                       color: Colors.black,
                      //                                     ),
                      //                                   ),
                      //                                   SizedBox(width: AppSize.scrWidth * 0.05,),
                      //                                   InkWell(
                      //                                     onTap: () {
                      //                                       pickFile(ImageSource.gallery);
                      //                                       Navigator.pop(context);
                      //                                     },
                      //                                     child: Container(
                      //                                       height: AppSize.scrWidth * 0.1,
                      //                                       width: AppSize.scrWidth * 0.1,
                      //                                       decoration: BoxDecoration(
                      //                                           color: Colors.white,
                      //                                           borderRadius:
                      //                                           BorderRadius.circular(AppSize.scrWidth * 0.04),
                      //                                           border: Border.all(
                      //                                               color: Colors.grey)),
                      //                                       child: const Icon(Icons.image,
                      //                                         color: Colors.black,
                      //                                       ),
                      //                                     ),
                      //                                   )
                      //                                 ],
                      //                               )
                      //                             ],
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   );
                      //                 },
                      //               );
                      //             },
                      //             child: Container(
                      //                 height: AppSize.scrWidth * 0.05,
                      //                 width: AppSize.scrWidth * 0.05,
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.green,
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomRight:
                      //                         Radius.circular(AppSize.scrWidth * 0.02),
                      //                         topLeft:
                      //                         Radius.circular(AppSize.scrWidth * 0.02))),
                      //                 child: Icon(Icons.add,
                      //                   color: Colors.white,
                      //                   size: AppSize.scrWidth * 0.03,
                      //                 )) //SvgPicture.asset(iconConst.edit),
                      //         ))
                      //   ],
                      // ):
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: widget.userProfile.isNotEmpty? NetworkImage(
                            widget.userProfile,
                          ):const AssetImage("assets/images/person.png")
                      ),
                      Column(
                        children: [
                          Text(widget.postCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text('Posts'),
                        ],
                      ),
                      // StreamBuilder<DocumentSnapshot>(
                      //   stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
                      //   builder: (context, snapshot) {
                      //     if(!snapshot.hasData){
                      //       const Column(
                      //         children: [
                      //           Text("",
                      //               style: TextStyle(fontWeight: FontWeight.bold)),
                      //           Text('Followers'),
                      //         ],
                      //       );
                      //     SizedBox(width: AppSize.scrWidth*0.07,);
                      //     const Column(
                      //     children: [
                      //     Text('0',style: TextStyle(fontWeight: FontWeight.bold,)),
                      //     Text('Following'),
                      //     ],
                      //     );
                      //     }
                      //     var userData=snapshot.data;
                      //     List following = snapshot.data?['following'];
                      //     List followers= snapshot.data?['followers'];
                      //     return
                            Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => FollowList(followerList: followers, followingList: following,),));
                                },
                                child: const Column(
                                  children: [
                                    Text("0",
                                        // followerData!.followers.length.toString(),
                                        // followers.length.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Followers'),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSize.scrWidth*0.07,),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => FollowList(followerList: followers, followingList: following,),));
                                },
                                child: const Column(
                                  children: [
                                    Text("0",
                                        // followerData!.following.length.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold,)),
                                    Text('Following'),
                                  ],
                                ),
                              ),
                            ],
                          )

                    ],
                  ),
                  SizedBox(height: AppSize.scrWidth*0.03,),
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSize.scrWidth*0.02,),
                  Text(
                    widget.userBio,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSize.scrWidth*0.1,),
                  // currentUserId==widget.userId? Row(
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));
                  //       },
                  //       child: Container(
                  //         height: AppSize.scrHeight*0.04,
                  //         width: AppSize.scrWidth*0.38,
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey.shade300,
                  //             borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                  //         ),
                  //         child: const Center(child: Text("Edit Profile",
                  //           style:TextStyle(
                  //               fontWeight: FontWeight.w600
                  //           ) ,)),
                  //       ),
                  //     ),
                  //     SizedBox(width: AppSize.scrWidth*0.02,),
                  //     Container(
                  //       height: AppSize.scrHeight*0.04,
                  //       width: AppSize.scrWidth*0.38,
                  //       decoration: BoxDecoration(
                  //           color: Colors.grey.shade300,
                  //           borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                  //       ),
                  //       child: const Center(child: Text("Share Profile",
                  //         style:TextStyle(
                  //             fontWeight: FontWeight.w600
                  //         ) ,)),
                  //     ),
                  //     SizedBox(width: AppSize.scrWidth*0.02,),
                  //     Container(
                  //         height: AppSize.scrHeight*0.04,
                  //         width: AppSize.scrWidth*0.09,
                  //         decoration: BoxDecoration(
                  //             color: Colors.grey.shade300,
                  //             borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                  //         ),
                  //         child: const Icon(Icons.person_add)
                  //     ),
                  //
                  //   ],
                  // ):
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          followController.toggleFollow();
                        },
                        child: Container(
                          height: AppSize.scrHeight * 0.04,
                          width: AppSize.scrWidth * 0.38,
                          decoration: BoxDecoration(
                            color: isFollowing ? Colors.grey[300] : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(AppSize.scrWidth * 0.02),
                          ),
                          child: Center(
                            child: Text(
                              isFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                color: isFollowing ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // if(!isPress)InkWell(
                      //   onTap: () {
                      //     ref.read(isPressed.notifier).state=true;
                      //   },
                      //   child: Container(
                      //     height: AppSize.scrHeight*0.04,
                      //     width: AppSize.scrWidth*0.38,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blueAccent,
                      //       borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02)
                      //     ),
                      //     child: const Center(child: Text("Follow",style: TextStyle(color: Colors.white),)),
                      //   ),
                      // ),
                      // if(isPress)InkWell(
                      //     onTap: () {
                      //       ref.read(isPressed.notifier).state=false;
                      //     },
                      //     child: Container(
                      //       height: AppSize.scrHeight*0.04,
                      //       width: AppSize.scrWidth*0.38,
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey[300],
                      //           borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02)
                      //       ),
                      //       child: const Center(child: Text("Following",)),
                      //     ),
                      //   ),
                      SizedBox(width: AppSize.scrWidth*0.02,),
                      Container(
                        height: AppSize.scrHeight*0.04,
                        width: AppSize.scrWidth*0.38,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02)
                        ),
                        child: const Center(child: Text("Message",)),
                      ),
                      SizedBox(width: AppSize.scrWidth*0.02,),
                      Container(
                        height: AppSize.scrHeight*0.04,
                        width: AppSize.scrWidth*0.09,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02)
                        ),
                        child: const Icon(Icons.person_add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: AppSize.scrWidth*0.03,),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.video_library)),
                Tab(icon: Icon(Icons.person_pin_outlined)),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              indicatorWeight: 2.0,
            ),
            Flexible(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection("post")
                          .where("uId",isEqualTo: widget.userId)
                          .where("delete",isEqualTo: false)
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewPost(
                                  postUrl: data[index]["image"],
                                  userId:  data[index]["uId"],
                                  initialIndex: index,
                                  postId: data[index]["id"],
                                  // postDetails: data,
                                ),));
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

                  // Third tab (Tagged posts)
                  const Center(
                    child: Text('Tagged Posts View'),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: TabBarView(
            //     children: [
            //       ref.watch(getPost).when(
            //     data: (data) {
            //       return GridView.builder(
            //         itemCount: data.length,
            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 3,
            //           crossAxisSpacing: 2,
            //           mainAxisSpacing: 2,
            //         ),
            //         itemBuilder: (context, index) {
            //           return Container(
            //             decoration:  BoxDecoration(
            //               image: DecorationImage(
            //                 image: NetworkImage(data[index].image),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     error: (error, stackTrace) => Text(error.toString()),
            //     loading: () => const CircularProgressIndicator(),),
            //
            //
            //       // Second tab (Reels)
            //       const Center(
            //         child: Text('Reels View'),
            //       ),
            //
            //       // Third tab (Tagged posts)
            //       const Center(
            //         child: Text('Tagged Posts View'),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
