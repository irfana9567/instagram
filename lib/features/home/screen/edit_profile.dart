import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/common/constants/constant.dart';
import 'package:instagram/common/constants/imagesConst.dart';
import 'package:instagram/features/home/screen/edit_page.dart';
import 'package:instagram/features/home/screen/home_screen.dart';
import 'package:instagram/features/home/screen/profile_picture.dart';
import 'package:instagram/features/home/screen/user_profiles/screen/user_account.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/navigation/profile.dart';

import '../../../image_picker_service.dart';
import '../../../model/post_model.dart';
import '../controller/home_controller.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});
  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {

  TextEditingController name=TextEditingController();
  TextEditingController userName=TextEditingController();
  TextEditingController bio=TextEditingController();
  TextEditingController gender=TextEditingController();

  bool isLoading = false;


  UserModel? userData;
  getuserData()async{
    userData=await ref.read(homeControllerProvider.notifier).getUser();
    name.text=userData!.name;
    userName.text=userData!.userName;
    bio.text=userData!.bio;
    gender.text=userData!.gender;
  }
  XFile? imageFile;
  void onClick()async{
    imageFile=await ImagePickerService().pickCropImage(
        cropAspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 16),
        imageSource: ImageSource.gallery);
    setState(() {
    });
  }
  var file;
  String imgurl = currentUser?.profile ?? 'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=';
  pickFile(ImageSource source, BuildContext context) async {
    imageFile=await ImagePickerService().pickCropImage(
        cropAspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 16),
        imageSource: ImageSource.gallery);
    setState(() {
      file = File(imageFile!.path);
    });

    Navigator.pop(context);
    // if (mounted) {
    //   setState(() {
    //     file = File(imageFile.path);
    //   });
    //   // await uploadFile(file!, context);
    // }
  }

  uploadFile(File file, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      var uploadTask = await FirebaseStorage.instance
          .ref("user")
          .child(DateTime.now().toString())
          .putFile(file, SettableMetadata(contentType: "image/jpg"));

      var getUrl = await uploadTask.ref.getDownloadURL();
      imgurl = getUrl;


      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .update({"profile": imgurl});

      setState(() {
        imgurl = getUrl;
        isLoading = false;
      });
      updatePostData();

      print("Profile image uploaded: $imgurl");

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 3,),), (route) => false,);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error uploading file: $e");
    }
  }

  deleteProfilePicture(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if (currentUser?.profile != null && currentUser!.profile != '') {
      try {
        await FirebaseStorage.instance.refFromURL(currentUser!.profile).delete();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserId)
            .update({"profile": null});

        setState(() {
          imgurl = 'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI='; // Default image URL
          isLoading = false; // Stop loading after deletion
        });

        print("Profile image deleted successfully.");

        // Close the Bottom Sheet after deleting
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading in case of error
        });
        print("Error deleting profile picture: $e");
      }
    }
  }

  updatePostData()async{
    ref.read(homeControllerProvider.notifier).updatePost(imgurl);
    ref.read(homeControllerProvider.notifier).updateStory(imgurl);
    ref.read(homeControllerProvider.notifier).updateComment(imgurl);
  }


  // pickFile(ImageSource) async{
  //   final imageFile=await ImagePicker.platform.pickImage(source:ImageSource);
  //   file=File(imageFile!.path);
  //   if(mounted){
  //     print(file);
  //     setState(() {
  //       file=File(imageFile.path);
  //     });
  //     uploadFile(file!);
  //   }
  //   Navigator.pop(context);
  // }
  // uploadFile(File file) async {
  //   var uploadtask=await FirebaseStorage.instance.ref("user").child(DateTime.now().toString()).putFile(file,
  //       SettableMetadata(contentType: "image/jpg"));
  //
  //   var geturl=await uploadtask.ref.getDownloadURL();
  //   imgurl = geturl;
  //   FirebaseFirestore.instance.collection("users").doc(currentUserId).update(
  //       {"profile":imgurl});
  //   setState(() {
  //
  //   });
  //   Navigator.pop(context);
  //   print(geturl);
  // }
  // deleteProfilePicture() async {
  //   if (currentUser?.profile != null && currentUser!.profile != '') {
  //     try {
  //       // Delete the current profile picture from Firebase Storage
  //       await FirebaseStorage.instance.refFromURL(currentUser!.profile).delete();
  //
  //       // Update Firestore to revert to the default profile picture or null
  //       await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(currentUserId)
  //           .update({"profile": null}); // or use a default URL for profile
  //
  //       setState(() {
  //         imgurl = 'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI='; // default image URL
  //       });
  //        Navigator.pop(context);
  //       print("Profile image deleted successfully.");
  //     } catch (e) {
  //       print("Error deleting profile picture: $e");
  //     }
  //   }
  // }
  @override
  void initState() {
    // name.text=currentUser?.name??"";
    // TODO: implement initState
    getuserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const HomeScreen(selectedIndex: 3,),));
            },
            child: const Icon(Icons.arrow_back)),
        title:  Text("Edit profile",
          style: TextStyle(
              fontSize: AppSize.scrWidth*0.05,
              fontWeight: FontWeight.w900
          ),),
      ),
      body:   SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(AppSize.scrWidth*0.05),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              file!=null?
              Column(
                children: [
                  SizedBox(
                    height: AppSize.scrHeight*0.6,
                    width: AppSize.scrWidth,
                    child: Image.file(
                      File(file!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.03,),
                  GestureDetector(
                    onTap: () {
                      uploadFile(file, context);
                    },
                    child: Container(
                      height: AppSize.scrHeight*0.05,
                      width: AppSize.scrWidth*0.3,
                      color: Colors.blueAccent,
                      child: const Center(child: Text("Next",style: TextStyle(color: Colors.white),)),
                    ),
                  )

                ],
              )
                  :
              Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            imgurl.isNotEmpty?NetworkImage(imgurl):const AssetImage("assets/images/person.png")
                          // currentUser?.profile != null
                          //     ? NetworkImage(currentUser!.profile)
                          //     : const AssetImage(imageConst.person)
                        ),
                        SizedBox(height:AppSize.scrHeight*0.02,),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return BottomSheet(
                                  onClosing: () {},
                                  showDragHandle: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.all(AppSize.scrWidth*0.05),
                                      child: SizedBox(
                                        height: AppSize.scrHeight*0.25,
                                        width: AppSize.scrWidth*1,
                                        child:


                                        isLoading?
                                        const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 10),
                                            Text('Loading'),
                                          ],
                                        )
                                            :Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                                radius: 21,
                                                backgroundImage:imgurl.isNotEmpty?NetworkImage(imgurl):const AssetImage("assets/images/person.png")
                                              // currentUser?.profile != null
                                              //     ? NetworkImage(currentUser!.profile)
                                              //     : const AssetImage(imageConst.person) ,
                                            ),

                                            imgurl.isNotEmpty?
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      pickFile(ImageSource.gallery,context);
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.image_outlined),
                                                      SizedBox(width: AppSize.scrWidth*0.03,),
                                                      const Text("New profile picture")
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: AppSize.scrHeight*0.02,),
                                                InkWell(
                                                  onTap: () {
                                                    deleteProfilePicture(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.delete,color: Colors.red,),
                                                      SizedBox(width: AppSize.scrWidth*0.03,),
                                                      const Text("Remove current profile picture")
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ) :
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  pickFile(ImageSource.gallery,context);
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.image_outlined),
                                                  SizedBox(width: AppSize.scrWidth*0.03,),
                                                  const Text("New profile picture")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: const Text("Edit Picture",
                            style: TextStyle(color: Colors.blueAccent),),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.04,),
                  TextFormField(
                    controller: name,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditPage(
                        title: "Name",
                        userDetail:name.text,
                        // userData:userData!,
                      ),));
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.02,),
                  TextFormField(
                    controller: userName,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditPage(
                        title: "Username",
                        userDetail:userName.text,
                        // userData: userData!,
                      ),));
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "Username"
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.02,),
                  TextFormField(
                    controller: bio,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditPage(
                        title: "Bio",
                        userDetail:bio.text,
                        // userData: userData!,
                      ),));
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "Bio"
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.02,),
                  TextFormField(
                    controller: gender,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditPage(
                        title: "Gender",
                        userDetail:bio.text,
                      ),));
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "Gender",
                        suffixIcon: Icon(Icons.arrow_forward_ios)
                    ),
                  ),
                  SizedBox(height: AppSize.scrHeight*0.02,),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
