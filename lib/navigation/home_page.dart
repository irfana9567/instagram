import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/features/home/controller/home_controller.dart';
import 'package:instagram/features/home/screen/messages.dart';
import 'package:instagram/features/home/screen/story_viewer.dart';
import 'package:instagram/features/home/screen/widgets/HeartAnimationWidget.dart';
import 'package:instagram/features/home/screen/widgets/commentlistWidget.dart';
import 'package:instagram/features/home/screen/widgets/customAppbar.dart';
import 'package:instagram/features/home/screen/widgets/storyWidget.dart';
import 'package:instagram/features/home/screen/widgets/story_avatar.dart';
import 'package:instagram/model/comment_model.dart';
import 'package:instagram/model/post_model.dart';
import 'package:instagram/model/story_model.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/navigation/profile.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';

import '../common/constants/constant.dart';
import '../common/constants/imagesConst.dart';
import '../features/home/screen/home_screen.dart';
import '../features/home/screen/user_profiles/screen/user_account.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
class _HomePageState extends ConsumerState<HomePage> {

  String? highlightedCommentId;

  bool isUploading = false;
  bool hasCurrentUserStory = false;
  Map<String, bool> isLikedMap = {};
  bool isLikeAnimating = false;

  int cmdCount=0;
  final _formKey = GlobalKey<FormState>();

  PostModel? postData;
  TextEditingController commentController=TextEditingController();
  final FocusNode focusNode = FocusNode();
  StateProvider isChangedData=StateProvider((ref) => false,);
  StateProvider isPressed=StateProvider((ref) => false,);
  StateProvider isuploaded=StateProvider((ref) => true,);

  String? downloadUrl;

  Future<void> pickAndUploadStory() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      hasCurrentUserStory = true;
      File imageFile = File(pickedFile.path);
      await uploadStory(imageFile);  // Upload the story and get the download URL
    }
  }

  Future<void> uploadStory(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('stories/$fileName')
          .putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      setState(() {
        downloadUrl = url;
      });

      uploadStoryData();
    } catch (e) {
      print(e.toString());
    }
  }

  uploadStoryData() {
    if (downloadUrl != '') {
      StoryModel uploadedStory = StoryModel(
        uId: currentUserId,
        mId: '',
        media: downloadUrl!,
        userName: currentUser?.userName ?? "",
        createdAt: DateTime.now(),
        userProfile: currentUser?.profile ?? "",
        delete: false,
      );
      ref.read(homeControllerProvider.notifier).uploadStories(context, storymodel: uploadedStory);
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  Future<void> savePost(String postId, String uid, List saveUser) async {
    try {
      if (saveUser.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'saveUser': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).update({
          'saveUser': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  Future<void> likeComment(String postId,String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        FirebaseFirestore.instance.collection('post').doc(postId).collection('comments').doc(commentId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        FirebaseFirestore.instance.collection('post').doc(postId).collection('comments').doc(commentId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      error.toString();
    }
  }

  addComment(String pId)async{
    CommentModel commentData=CommentModel(
        commentId: '',
        postId: pId,
        userId: currentUserId,
        comment: commentController.text,
        date: DateTime.now(),
        userName: currentUser?.userName??"",
        userProfile: currentUser?.profile??"",
        like: [],
        delete: false
    );

    final isChangeData = ref.watch(isChangedData);
    if(isChangeData){
      ref.read(homeControllerProvider.notifier).addComments(pId, commentModel: commentData);
      commentController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  deleteComments(String cmtId,String postId){
    ref.read(homeControllerProvider.notifier).deleteComment(context: context, pId: postId, cId: cmtId);
  }
  clear(){
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Row(
          children: [
            SizedBox(
              height: AppSize.scrHeight*0.06,
              width: AppSize.scrWidth*0.4,
              child: const Image(image: AssetImage(imageConst.logotext),fit:BoxFit.fill,),
            )
          ],
        ) ,
        actions: [
          SizedBox(
              height: AppSize.scrHeight*0.06,
              width: AppSize.scrWidth*0.06,
              child: SvgPicture.asset(iconConst.notification)),
          SizedBox(width: AppSize.scrWidth*0.01,),
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const Messages(),));
              },
              child: Padding(
                padding: EdgeInsets.all(AppSize.scrWidth*0.05),
                child:  SizedBox(
                  height: AppSize.scrHeight * 0.03,
                  width: AppSize.scrWidth * 0.06,
                  child: SvgPicture.asset(iconConst.share),
                ),
              ))

        ],
      ),
      body:  SingleChildScrollView(
        child:
        Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Add Story Button
                  Column(
                    children: [
                      downloadUrl==""?
                      GestureDetector(
                        onTap: () {
                          pickAndUploadStory();
                          print(downloadUrl);
                          print("##################");
                        },
                        child:   Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: currentUser!.profile.isNotEmpty? NetworkImage(currentUser!.profile):const AssetImage("assets/images/person.png"),),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.add, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      ref.watch(yourStory).when(
                        data: (data) {
                          final String mediaUrl=data[0].media;
                          final String profileUrl=data[0].userProfile;
                          final String mId=data[0].mId;
                          final String name=data[0].userName;
                          final String uId=data[0].uId;
                          print(data[0].userName);
                          print(data[0].mId);
                          print("***************88888");
                          return   AnimatedStoryAvatar(
                            imageUrl: data[0].media,
                            profileUrl:data[0].userProfile ,
                            hasStory: true,
                            onStoryLoadComplete: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryViewer(
                                    imageUrl:mediaUrl,
                                    docId: mId,
                                    userProfile:profileUrl ,
                                    userName:name ,
                                    userId: uId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () =>const CircularProgressIndicator() ,
                      ),
                      const SizedBox(height: 8),
                      const Text("Your story"),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Display other stories
                  StoryWidget()

                ],
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: SizedBox(
            //           height: AppSize.scrHeight*0.16,
            //           child: ref.watch(getStory).when(
            //             data: (data) {
            //               return
            //                 ListView.separated(
            //                 physics: const BouncingScrollPhysics(),
            //                 shrinkWrap: true,
            //                 itemCount: data.length,
            //                 scrollDirection: Axis.horizontal,
            //                 itemBuilder: (context, index) {
            //                   return Column(
            //                     children: [
            //
            //                       data[index].uId==currentUserId?  InkWell(
            //                         onTap: () {
            //                           pickAndUploadStory();
            //                         },
            //                         child:  Stack(
            //                           children: [
            //                             CircleAvatar(
            //                                 radius: 45,
            //                                 backgroundImage: data[index].userProfile.isNotEmpty?
            //                                 NetworkImage(data[index].userProfile):const AssetImage("assets/images/person.png")
            //                             ) ,
            //                             const Positioned(
            //                                 bottom: 0,
            //                                 right: 6,
            //                                 child: CircleAvatar(
            //                                   backgroundColor: Colors.blue,
            //                                   radius: 12,
            //                                   child: Icon(Icons.add,color: Colors.white,),
            //                                 )
            //                             )
            //                           ],
            //                         ),
            //                       )
            //                      : AnimatedStoryAvatar(
            //                         imageUrl: data[index].media,
            //                         profileUrl: data[index].userProfile,
            //                         hasStory: true,
            //                         onStoryLoadComplete: () {
            //                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  StoryViewer(imageUrl:data[index].media ,),));
            //                         },),
            //
            //                       data[index].uId==currentUserId? const Text("Your story"):Text(data[index].userName)
            //                       // Text(data[index].name),
            //                     ],
            //                   );
            //                 },
            //                 separatorBuilder: (context, index) {
            //                   return SizedBox(
            //                     width: AppSize.scrWidth*0.02,
            //                   );
            //                 },
            //               );
            //               //   ListView.separated(
            //               //   physics: const BouncingScrollPhysics(),
            //               //   shrinkWrap: true,
            //               //   itemCount: data.length,
            //               //   scrollDirection: Axis.horizontal,
            //               //   itemBuilder: (context, index) {
            //               //     return Column(
            //               //       children: [
            //               //         data[index].id==currentUserId?  InkWell(
            //               //           onTap: () {
            //               //             pickAndUploadStory();
            //               //           },
            //               //           child: Stack(
            //               //             children: [
            //               //                CircleAvatar(
            //               //                   radius: 45,
            //               //                   backgroundImage: data[index].profile.isNotEmpty?NetworkImage(data[index].profile):const AssetImage("assets/images/person.png")) ,
            //               //               const Positioned(
            //               //                   bottom: 0,
            //               //                   right: 6,
            //               //                   child: CircleAvatar(
            //               //                     backgroundColor: Colors.blue,
            //               //                     radius: 12,
            //               //                     child: Icon(Icons.add,color: Colors.white,),
            //               //                   )
            //               //               )
            //               //             ],
            //               //           ),
            //               //         ) :
            //               //          InkWell(
            //               //            onTap: () {
            //               //              Navigator.push(context, MaterialPageRoute(builder: (context) => const StoryViewer(imageUrl: '',),));
            //               //            },
            //               //            child: CircleAvatar(
            //               //               radius: 45,
            //               //               backgroundImage: ,
            //               //                                             ),
            //               //  data[index].profile.isNotEmpty? NetworkImage(data[index].profile):const AssetImage("assets/images/person.png")
            //               //          ) ,
            //               //
            //               //         data[index].id==currentUserId? const Text("Your story"):Text(data[index].userName)
            //               //         // Text(data[index].name),
            //               //       ],
            //               //     );
            //               //   },
            //               //   separatorBuilder: (context, index) {
            //               //     return SizedBox(
            //               //       width: AppSize.scrWidth*0.02,
            //               //     );
            //               //   },
            //               // );
            //             },
            //             error: (error, stackTrace) => Text(error.toString()),
            //             loading:() => const CircularProgressIndicator(),)
            //       ),
            //     ),
            //   ],
            // ),
            ref.watch(getPost).when(
              data: (data) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(AppSize.scrWidth*0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  currentUserId==data[index].uId ? Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(selectedIndex: 3,),)):
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserAccount(
                                      userProfile: data[index].userProfile,
                                      userName: data[index].userName,
                                      postCount: data.length,
                                      userBio:data[index].userBio,
                                      name: data[index].name,
                                      userId:  data[index].uId
                                  ),));
                                },
                                child: Row(
                                  children: [
                                    data[index].userProfile.isNotEmpty? CircleAvatar(
                                        backgroundImage: NetworkImage(data[index].userProfile)
                                    ) :
                                    const CircleAvatar(backgroundImage:AssetImage("assets/images/person.png") ,),
                                    SizedBox(width: AppSize.scrWidth*0.02,),
                                    Text(data[index].userName),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: AppSize.scrHeight*0.03,
                                  width: AppSize.scrWidth*0.06,
                                  child: SvgPicture.asset(iconConst.dots,)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            likePost(
                              data[index].id,
                              currentUserId,
                              data[index].like,
                            );
                            setState(() {
                              isLikeAnimating = true;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: AppSize.scrHeight * 0.62,
                                width: AppSize.scrWidth * 1,
                                child: Image(
                                  image: NetworkImage(data[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isLikeAnimating ? 1 : 0,
                                child: LikeAnimation(
                                  isAnimating: isLikeAnimating,
                                  duration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  onEnd: () {
                                    setState(() {
                                      isLikeAnimating = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSize.scrWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      LikeAnimation(
                                        isAnimating: data[index].like.contains(currentUserId),
                                        smallLike: true,
                                        child: IconButton(
                                          icon: data[index].like.contains(currentUserId)
                                              ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                              : const Icon(
                                            Icons.favorite_border,
                                          ),

                                          onPressed: ()=>
                                              likePost(
                                                data[index].id,
                                                currentUserId,
                                                data[index].like,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            showDragHandle: true,
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: AppSize.scrHeight*0.9,
                                                child: Column(
                                                  children: [
                                                    const Text("Comments",style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                    Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                            stream: FirebaseFirestore.instance.collection('post').doc(data[index].id)
                                                                .collection('comments')
                                                                .where('postId',isEqualTo: data[index].id)
                                                                .where('delete',isEqualTo: false)
                                                                .orderBy('date',descending: true)
                                                                .snapshots(),
                                                            builder: (context, snapshot) {
                                                              if (!snapshot.hasData) {
                                                                return const Center(child:CircularProgressIndicator());
                                                              }
                                                              var data = snapshot.data;
                                                              return
                                                                SizedBox(
                                                                  child: data!.docs.isEmpty? const Center(child: Text("No comments yet!")):
                                                                  ListView.separated(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    shrinkWrap: true,
                                                                    itemCount:data.docs.length,
                                                                    itemBuilder: (context, index) {
                                                                      return GestureDetector(
                                                                        onLongPress: () {
                                                                          showDialog(
                                                                            barrierDismissible: false,
                                                                            context: context,
                                                                            builder: (context) {
                                                                              return AlertDialog(
                                                                                title: Text(" Do you want to delete this comment?",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      fontSize: AppSize.scrHeight*0.02,
                                                                                      fontWeight: FontWeight.w600
                                                                                  ),),
                                                                                content: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const SizedBox(
                                                                                        height: 30,
                                                                                        width: 100,
                                                                                        child: Center(child: Text("No",
                                                                                          style: TextStyle(
                                                                                              color: Colors.black
                                                                                          ),)),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        deleteComments(data.docs[index]["commentId"],data.docs[index]["postId"]);
                                                                                      },
                                                                                      child: const SizedBox(
                                                                                        height: 30,
                                                                                        width: 100,
                                                                                        child: Center(child: Text("Yes",
                                                                                          style: TextStyle(
                                                                                              color: Colors.black
                                                                                          ),)),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            data.docs[index]["userProfile"] == ""
                                                                                ? const CircleAvatar(
                                                                              backgroundImage: AssetImage("assets/images/person.png"),
                                                                            )
                                                                                : CircleAvatar(
                                                                              backgroundImage: NetworkImage(data.docs[index]["userProfile"]),
                                                                            ),
                                                                            SizedBox(width: AppSize.scrWidth * 0.03),
                                                                            Expanded(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    data.docs[index]["userName"],
                                                                                    style: TextStyle(
                                                                                        fontSize: AppSize.scrWidth * 0.03, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(data.docs[index]["comment"]),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: AppSize.scrHeight*0.03,
                                                                                  width: AppSize.scrWidth*0.08,
                                                                                  child: LikeAnimation(
                                                                                    isAnimating: data.docs[index]["like"].contains(currentUserId),
                                                                                    smallLike: true,
                                                                                    child: IconButton(
                                                                                      icon: data.docs[index]["like"].contains(currentUserId)
                                                                                          ? Icon(
                                                                                        Icons.favorite,
                                                                                        color: Colors.red,
                                                                                        size: AppSize.scrWidth * 0.04,
                                                                                      )
                                                                                          : Icon(
                                                                                        Icons.favorite_outline,
                                                                                        color: Colors.grey,
                                                                                        size: AppSize.scrWidth * 0.04,
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        likeComment(
                                                                                          data.docs[index]["postId"],
                                                                                          data.docs[index]["commentId"],
                                                                                          currentUserId,
                                                                                          data.docs[index]["like"],
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                data.docs[index]['like'].length!=0? Text( data.docs[index]['like'].length.toString(),
                                                                                  style: TextStyle(fontSize: AppSize.scrWidth * 0.03,color: Colors.grey),
                                                                                ):const Text("")
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder: (BuildContext context, int index) {
                                                                      return SizedBox(height: AppSize.scrHeight*0.015,);
                                                                    },
                                                                  ),
                                                                );
                                                            }
                                                        )
                                                    ),

                                                    Padding(
                                                      padding:  EdgeInsets.only(
                                                        right: AppSize.scrWidth*0.04,
                                                        left: AppSize.scrWidth*0.04,
                                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: AppSize.scrWidth*0.75,
                                                            child: TextFormField(
                                                              controller:commentController,
                                                              focusNode:focusNode,
                                                              onChanged: (value) {
                                                                ref.read(isChangedData.notifier).state=true;
                                                              },
                                                              keyboardType: TextInputType.multiline,
                                                              style: TextStyle(
                                                                fontSize: AppSize.scrWidth*0.04,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              decoration: InputDecoration(
                                                                labelText:"Add a comment...",
                                                                labelStyle: TextStyle(
                                                                    fontSize:  AppSize.scrWidth*0.04,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Colors.grey
                                                                ),
                                                                border: OutlineInputBorder(
                                                                    borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06)
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06),
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.grey
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: AppSize.scrWidth*0.03,),
                                                          InkWell(
                                                            onTap: () {
                                                              addComment(data[index].id);
                                                            },
                                                            child:  Container(
                                                              height: AppSize.scrWidth*0.12,
                                                              width: AppSize.scrWidth*0.12,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02),
                                                                color: Colors.blueAccent,
                                                              ),
                                                              child: const Icon(Icons.arrow_upward,color: Colors.white,),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );

                                        },
                                        child: SizedBox(
                                          height: AppSize.scrHeight * 0.036,
                                          width: AppSize.scrWidth * 0.08,
                                          child: SvgPicture.asset(iconConst.comment, fit: BoxFit.fill),
                                        ),
                                      ),
                                      SizedBox(width: AppSize.scrWidth * 0.02),
                                      // SizedBox(
                                      //   height: AppSize.scrHeight * 0.03,
                                      //   width: AppSize.scrWidth * 0.06,
                                      //   child: SvgPicture.asset(iconConst.share),
                                      // ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        savePost(data[index].id,currentUserId,data[index].saveUser)
                                    ,
                                    icon: data[index].saveUser.contains(currentUserId) ?
                                    SizedBox(
                                        height: AppSize.scrHeight * 0.03,
                                        width: AppSize.scrWidth * 0.08,
                                        child: SvgPicture.asset(iconConst.filledBookmark,color: Colors.black,fit: BoxFit.fill,))
                                        : SizedBox(
                                        height: AppSize.scrHeight * 0.025,
                                        width: AppSize.scrWidth * 0.07,
                                        child: SvgPicture.asset(iconConst.save,color: Colors.black,)),

                                  )
                                ],
                              ),
                              SizedBox(height: AppSize.scrWidth * 0.01),
                              Row(
                                children: [
                                  Text("${data[index].like.length.toString()} Likes",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSize.scrWidth * 0.01),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: AppSize.scrHeight*0.6,
                                        child: Column(
                                          children: [
                                            const Text("Comments",style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),),
                                            Expanded(
                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection('post').doc(data[index].id)
                                                        .collection('comments')
                                                        .where('postId',isEqualTo: data[index].id)
                                                        .where('delete',isEqualTo: false)
                                                        .orderBy('date',descending: true)
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Center(child:CircularProgressIndicator());
                                                      }
                                                      var cmdDoc = snapshot.data!.docs;
                                                      return
                                                        SizedBox(
                                                          child: cmdDoc.isEmpty? const Center(child: Text("No comments yet!")):
                                                          ListView.separated(
                                                            padding: const EdgeInsets.all(8.0),
                                                            shrinkWrap: true,
                                                            itemCount:cmdDoc.length,
                                                            itemBuilder: (context, index) {
                                                              return GestureDetector(
                                                                onLongPress: () {
                                                                  showDialog(
                                                                    barrierDismissible: false,
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return AlertDialog(
                                                                        title: Text(" Do you want to delete this comment?",
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: AppSize.scrHeight*0.02,
                                                                              fontWeight: FontWeight.w600
                                                                          ),),
                                                                        content: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const SizedBox(
                                                                                height: 30,
                                                                                width: 100,
                                                                                child: Center(child: Text("No",
                                                                                  style: TextStyle(
                                                                                      color: Colors.black
                                                                                  ),)),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                deleteComments(cmdDoc[index]["commentId"],cmdDoc[index]["postId"]);
                                                                              },
                                                                              child: const SizedBox(
                                                                                height: 30,
                                                                                width: 100,
                                                                                child: Center(child: Text("Yes",
                                                                                  style: TextStyle(
                                                                                      color: Colors.black
                                                                                  ),)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    cmdDoc[index]["userProfile"] == ""
                                                                        ? const CircleAvatar(
                                                                      backgroundImage: AssetImage("assets/images/person.png"),
                                                                    )
                                                                        : CircleAvatar(
                                                                      backgroundImage: NetworkImage(cmdDoc[index]["userProfile"]),
                                                                    ),
                                                                    SizedBox(width: AppSize.scrWidth * 0.03),
                                                                    Expanded(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            cmdDoc[index]["userName"],
                                                                            style: TextStyle(
                                                                                fontSize: AppSize.scrWidth * 0.03, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(cmdDoc[index]["comment"]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        SizedBox(
                                                                          height: AppSize.scrHeight*0.03,
                                                                          width: AppSize.scrWidth*0.08,
                                                                          child: LikeAnimation(
                                                                            isAnimating: cmdDoc[index]["like"].contains(currentUserId),
                                                                            smallLike: true,
                                                                            child: IconButton(
                                                                              icon: cmdDoc[index]["like"].contains(currentUserId)
                                                                                  ? Icon(
                                                                                Icons.favorite,
                                                                                color: Colors.red,
                                                                                size: AppSize.scrWidth * 0.04,
                                                                              )
                                                                                  : Icon(
                                                                                Icons.favorite_outline,
                                                                                color: Colors.grey,
                                                                                size: AppSize.scrWidth * 0.04,
                                                                              ),
                                                                              onPressed: () {
                                                                                likeComment(
                                                                                  cmdDoc[index]["postId"],
                                                                                  cmdDoc[index]["commentId"],
                                                                                  currentUserId,
                                                                                  cmdDoc[index]["like"],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        cmdDoc[index]['like'].length!=0? Text( cmdDoc[index]['like'].length.toString(),
                                                                          style: TextStyle(fontSize: AppSize.scrWidth * 0.03,color: Colors.grey),
                                                                        ):const Text("")
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),

                                                              );
                                                            },
                                                            separatorBuilder: (BuildContext context, int index) {
                                                              return SizedBox(height: AppSize.scrHeight*0.015,);
                                                            },
                                                          ),
                                                        );
                                                    }
                                                )
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(
                                                right: AppSize.scrWidth*0.04,
                                                left: AppSize.scrWidth*0.04,
                                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: AppSize.scrWidth*0.75,
                                                    child: TextFormField(
                                                      controller:commentController,
                                                      focusNode:focusNode,
                                                      onChanged: (value) {
                                                        ref.read(isChangedData.notifier).state=true;
                                                      },
                                                      keyboardType: TextInputType.multiline,
                                                      style: TextStyle(
                                                        fontSize: AppSize.scrWidth*0.04,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      decoration: InputDecoration(
                                                        labelText:"Add a comment...",
                                                        labelStyle: TextStyle(
                                                            fontSize:  AppSize.scrWidth*0.04,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.grey
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06)
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:BorderRadius.circular(AppSize.scrWidth*0.06),
                                                            borderSide: const BorderSide(
                                                                color: Colors.grey
                                                            )
                                                          // )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: AppSize.scrWidth*0.03,),
                                                  InkWell(
                                                    onTap: () {
                                                      addComment(data[index].id);
                                                    },
                                                    child:  Container(
                                                      height: AppSize.scrWidth*0.12,
                                                      width: AppSize.scrWidth*0.12,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(AppSize.scrWidth*0.02),
                                                        color: Colors.blueAccent,
                                                      ),
                                                      child: const Icon(Icons.arrow_upward,color: Colors.white,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                },
                                child:    const Row(
                                  children: [
                                    Text('View all comments',style:TextStyle(
                                        color: Colors.grey
                                    ),),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSize.scrWidth * 0.01),
                              ReadMoreText(
                                data[index].description,
                                // trimMode: TrimMode.Line,
                                trimLines: 2,
                                colorClickableText: Colors.pink,
                                trimCollapsedText: 'more',
                                trimExpandedText: 'less',
                                moreStyle: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                ),
                                lessStyle: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: AppSize.scrHeight*0.02,
                    );
                  },
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






