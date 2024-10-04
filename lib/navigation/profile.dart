import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/features/auth/screen/login_page.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/features/home/screen/edit_profile.dart';
import 'package:instagram/features/home/screen/saved_media.dart';
import 'package:instagram/features/home/screen/settings.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/follow_list.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:instagram/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants/imagesConst.dart';
import '../features/home/screen/view_post.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}
class _ProfileState extends ConsumerState<Profile> {
  String _value='one';
  var file;
  String imgurl = currentUser?.profile ?? 'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=';

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
  // pickFile(ImageSource source) async {
  //   try {
  //     final imageFile = await ImagePicker().pickImage(source: source);
  //     if (imageFile == null) return;
  //
  //     File file = File(imageFile.path);
  //
  //     // Upload the file
  //     var uploadTask = await FirebaseStorage.instance
  //         .ref("user")
  //         .child(DateTime.now().toString())
  //         .putFile(file, SettableMetadata(contentType: "image/jpg"));
  //
  //     // Get the uploaded image URL
  //     String newImgUrl = await uploadTask.ref.getDownloadURL();
  //
  //     // Update Firestore and currentUser profile URL
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(currentUserId)
  //         .update({"profile": newImgUrl});
  //
  //     // Update the imgurl and UI
  //     setState(() {
  //       imgurl = newImgUrl; // Update the URL in the widget
  //     });
  //
  //   } catch (e) {
  //     print("Error picking or uploading file: $e");
  //   }
  // }
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


  Future<int> getDistinctUserCount() async {
    // Reference to the 'posts' collection
    CollectionReference postsCollection = FirebaseFirestore.instance.collection('post');

    try {
      // Fetch all documents in the 'posts' collection
      QuerySnapshot querySnapshot = await postsCollection.get();

      // Create a set to hold distinct userIds
      Set<String> distinctUserIds = {};

      // Loop through the documents and extract the userId
      querySnapshot.docs.forEach((doc) {
        String userId = doc['id'];  // Assuming each post has a 'userId' field
        distinctUserIds.add(userId);
      });

      // Return the count of distinct userIds
      return distinctUserIds.length;
    } catch (e) {
      print("Error fetching distinct user count: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:CustomAppBar(
            title: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _value,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: 'one',
                    child: Row(
                      children: [
                        Text(currentUser?.userName??""),
                      ],
                    ),
                  ),
                ],
                onChanged: (value){},
              ),
            ),
          actions: [
            // const Icon(Icons.add_box_outlined,),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),));
                },
                child: Padding(
                  padding: EdgeInsets.all(AppSize.scrWidth*0.03),
                  child: const Icon(Icons.list,color: Colors.black,),
                ))
            ],
        ),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(AppSize.scrWidth*0.05,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        children: [
                             SizedBox(
                            child:Column(
                              children: [
                               CircleAvatar(
                                  radius: 40,
                                  backgroundImage: imgurl.isNotEmpty?NetworkImage(imgurl):const AssetImage("assets/images/person.png")
                                )
                              ],
                            ) ,
                          ),
                          // Positioned(
                          //     bottom: 0,
                          //     right: 15,
                          //     child: InkWell(
                          //         onTap: () {
                          //           showDialog(
                          //             context: context,
                          //             builder: (context) {
                          //               return AlertDialog(
                          //                 title: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceEvenly,
                          //                   children: [
                          //                     InkWell(
                          //                       onTap: () {
                          //                         pickFile(ImageSource.camera);
                          //                         Navigator.pop(context);
                          //                       },
                          //                       child: Column(
                          //                         children: [
                          //                           Text(
                          //                             "Choose a file form",
                          //                             style: TextStyle(
                          //                                 fontSize: AppSize.scrWidth * 0.04),
                          //                           ),
                          //                           SizedBox(height: AppSize.scrWidth * 0.04,),
                          //                           Row(
                          //                             children: [
                          //                               Container(
                          //                                 height: AppSize.scrWidth * 0.1,
                          //                                 width: AppSize.scrWidth * 0.1,
                          //                                 decoration: BoxDecoration(
                          //                                     color: Colors.white,
                          //                                     borderRadius:
                          //                                     BorderRadius.circular(
                          //                                         AppSize.scrWidth * 0.04),
                          //                                     border: Border.all(
                          //                                         color:
                          //                                         Colors.grey)),
                          //                                 child: const Icon(
                          //                                   Icons.camera_alt_outlined,
                          //                                   color: Colors.black,
                          //                                 ),
                          //                               ),
                          //                               SizedBox(width: AppSize.scrWidth * 0.05,),
                          //                               InkWell(
                          //                                 onTap: () {
                          //                                   pickFile(ImageSource.gallery);
                          //                                   Navigator.pop(context);
                          //                                 },
                          //                                 child: Container(
                          //                                   height: AppSize.scrWidth * 0.1,
                          //                                   width: AppSize.scrWidth * 0.1,
                          //                                   decoration: BoxDecoration(
                          //                                       color: Colors.white,
                          //                                       borderRadius:
                          //                                       BorderRadius.circular(AppSize.scrWidth * 0.04),
                          //                                       border: Border.all(
                          //                                           color: Colors.grey)),
                          //                                   child: const Icon(Icons.image,
                          //                                     color: Colors.black,
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             ],
                          //                           )
                          //                         ],
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               );
                          //             },
                          //           );
                          //         },
                          //         child: Container(
                          //             height: AppSize.scrWidth * 0.05,
                          //             width: AppSize.scrWidth * 0.05,
                          //             decoration: BoxDecoration(
                          //                 color: Colors.blueAccent,
                          //                 borderRadius: BorderRadius.only(
                          //                     bottomRight:
                          //                     Radius.circular(AppSize.scrWidth * 0.02),
                          //                     topLeft:
                          //                     Radius.circular(AppSize.scrWidth * 0.02))),
                          //             child: Icon(Icons.add,
                          //               color: Colors.white,
                          //               size: AppSize.scrWidth * 0.03,
                          //             )) //SvgPicture.asset(iconConst.edit),
                          //     ))
                        ],
                      ),
                       Column(
                        children: [
                          FutureBuilder<int>(
                              future: getDistinctUserCount(),
                              builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return const CircularProgressIndicator(); // Loading indicator while waiting
                         } else if (snapshot.hasError) {
                           return const Text('Error', style: TextStyle(fontWeight: FontWeight.bold));
                         } else if (snapshot.hasData) {
                         return Text(
                           snapshot.data.toString(), // Converts true/false to text
                              style: const TextStyle(fontWeight: FontWeight.bold),
                             );
                           } else {
                           return const Text("0");
                           }}),
                          const Text('Posts'),
                        ],
                      ),
                       Column(
                        children: [
                          Text(currentUser?.followers.length.toString()??"", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text('followers'),
                        ],
                                             ),
                       Column(
                        children: [
                          Text(currentUser?.following.length.toString()??"",style: const TextStyle(fontWeight: FontWeight.bold,)),
                          const Text('Following'),
                        ],
                      ),
                      ],),
                      SizedBox(height: AppSize.scrWidth*0.03,),
                      Text(
                        currentUser!.userName,
                        style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSize.scrWidth*0.02,),
                      Text(
                        currentUser?.bio ?? "",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSize.scrWidth*0.1,),
                      Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));
                        },
                        child: Container(
                          height: AppSize.scrHeight*0.04,
                          width: AppSize.scrWidth*0.38,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                          ),
                          child: const Center(child: Text("Edit Profile",
                            style:TextStyle(
                                fontWeight: FontWeight.w600
                            ) ,)),
                        ),
                      ),
                      SizedBox(width: AppSize.scrWidth*0.02,),
                      Container(
                        height: AppSize.scrHeight*0.04,
                        width: AppSize.scrWidth*0.38,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                        ),
                        child: const Center(child: Text("Share Profile",
                          style:TextStyle(
                              fontWeight: FontWeight.w600
                          ) ,)),
                      ),
                      SizedBox(width: AppSize.scrWidth*0.02,),
                      Container(
                          height: AppSize.scrHeight*0.04,
                          width: AppSize.scrWidth*0.09,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(AppSize.scrWidth*0.03)
                          ),
                          child: const Icon(Icons.person_add)
                      ),

                    ],
                  ),
                ],
              ),
            ),

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
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection("post")
                          .where("uId",isEqualTo: currentUserId)
                          .where("delete",isEqualTo: false)
                          .orderBy("uploadDate",descending: true)
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
          ],
        ),
      ),
    );
  }
}
